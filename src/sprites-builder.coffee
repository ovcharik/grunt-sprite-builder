_        = require 'underscore'
fs       = require 'fs'
md5      = require 'md5'
path     = require 'path'
async    = require 'async'
slash    = require 'slash'
build    = require 'sprite-builder'
Mustache = require 'mustache'

defaultTemplates =
  'json': path.resolve __dirname, '..', 'templates', 'json.template'
  'less': path.resolve __dirname, '..', 'templates', 'less.template'
  'anim': path.resolve __dirname, '..', 'templates', 'anim.template'

spritesFolderHash = (src) ->
  buffer = ""
  files = fs.readdirSync src
  for file in files
    p = path.join src, file
    s = fs.statSync p
    buffer += "#{slash(p)}#{s.mtime.valueOf()}#{s.size}"
  md5(buffer)

writeTemplate = (input, output, data, grunt) ->
  templatePath = defaultTemplates[input] ? input
  template = fs.readFileSync templatePath, 'utf8'
  result = Mustache.render template, data
  fs.writeFileSync output, result, 'utf8'
  grunt.log.writeln "created: #{output}"

module.exports = (grunt) ->
  grunt.registerMultiTask 'spriteBuilder', 'Make sprite atlases', ->
    done = @async()

    options = @options
      method   : 'growing'
      padding  : 0
      trim     : false
      templates: {}
      cache    : true
      cacheFile: ".sprite-builder-cache.json"
    dest = @data.dest

    folders = []
    for file in @files
      folders = folders.concat file.src

    try
      oldSprites = fs.readdirSync(dest).map (file) ->
        path.join dest, file
    catch e
      console.log e
      oldSprites = []
    if options.cache
      try
        cacheData = grunt.file.readJSON options.cacheFile
      catch e
        cacheData = {}
    else
      cacheData = {}

    process = []
    results = {}

    for folder in folders
      do (folder) ->
        basename = path.basename folder
        name = path.join dest, "#{basename}-#{spritesFolderHash(folder)}.png"
        if _(oldSprites).include(name) and cacheData[name]
          results[name] = cacheData[name]
        else
          process.push (cb) ->
            build.processOne folder, { dest: name, padding: options.padding, method: options.method, trim: options.trim, templates: {} }, (error, result) ->
              return cb(error) if error
              results[name] = result
              results[name].basename = basename
              grunt.log.writeln "created: #{name}"
              cb(null)

    async.series process, (error) ->
      return done(false, error) if error

      # Удаляем старые
      for old in oldSprites when not results[old]
        fs.unlinkSync old
        grunt.log.writeln "deleted: #{old}"

      if process.length <= 0
        return done(true)

      # Формируем данные для шаблона
      data = { files: [] }
      fkeys = _.chain(results).keys().sortBy().value()
      for fkey, i in fkeys
        file = results[fkey]
        file.dest = slash(file.dest)
        file.isLastFile = i == (fkeys.length - 1)
        file.name = fkey
        file.spritesLength = file.sprites.length
        data.files.push file
        file.sprites = _(file.sprites).sortBy('name')
        _(file.sprites).each (s, j) ->
          s.dest = file.dest
          s.isLastSprite = j == file.sprites.length - 1

      for name, out of options.templates
        try
          writeTemplate name, out, data, grunt
        catch e
          grunt.log.writeln e

      if options.cache
        fs.writeFileSync options.cacheFile, JSON.stringify(results), 'utf8'

      return done(true)
