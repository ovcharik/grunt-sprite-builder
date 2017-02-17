_        = require 'underscore'
fs       = require 'fs'
md5      = require 'md5'
path     = require 'path'
async    = require 'async'
slash    = require 'slash'
build    = require 'sprite-builder'
Mustache = require 'mustache'

# default options
defaultOptions =
  method   : 'growing'
  padding  : 0
  trim     : true
  hashname : true
  cache    : true
  cacheFile: ".sprite-builder-cache.json"
  filter   : /\.png$/i
  templates: {}

defaultTemplates =
  'json': path.resolve __dirname, '..', 'templates', 'json.template'
  'less': path.resolve __dirname, '..', 'templates', 'less.template'
  'anim': path.resolve __dirname, '..', 'templates', 'anim.template'


# all files from `src` directory concat into buffer, and return md5-sum from buffer
spritesFolderHash = (src) ->
  buffer = ""
  files = fs.readdirSync src
  for file in files
    p = path.join src, file
    s = fs.statSync p
    buffer += "#{slash(p)}#{s.mtime.valueOf()}#{s.size}"
  md5(buffer)

# read template file from `input` and render template to `output` with `data`
writeTemplate = (input, output, data, grunt) ->
  templatePath = defaultTemplates[input] ? input
  template = fs.readFileSync templatePath, 'utf8'
  result = Mustache.render template, data
  fs.writeFileSync output, result, 'utf8'
  grunt.log.writeln "created: #{output}"


module.exports = (grunt) ->
  spriteBuilderMultiTask = ->
    done = @async()

    options = @options defaultOptions
    dest    = @data.dest
    folders = _(@files).reduce ((memo, file) -> memo.concat(file.src)), []

    # read old spritesheets from result directory
    try
      oldSprites = _(fs.readdirSync(dest)).map (file) -> path.join(dest, file)
    catch e
      grunt.log.error e
      oldSprites = []

    # read cache info
    if options.cache
      try
        cacheData = grunt.file.readJSON options.cacheFile
      catch e
        cacheData = {}
    else
      cacheData = {}

    process = [] # array of process handlers
    results = {} # meta-data about sprites

    _(folders).each (folder) ->
      basename = path.basename folder
      # result name of spritesheet
      name = if options.hashname
        path.join dest, "#{basename}-#{spritesFolderHash(folder)}.png"
      else
        path.join dest, "#{basename}.png"

      # check cache
      if _(oldSprites).include(name) and cacheData[name]
        results[name] = cacheData[name]
        return

      # add handler on process forlder
      process.push (cb) ->
        params =
          dest     : name
          method   : options.method
          padding  : options.padding
          trim     : options.trim
          filter   : options.filter
          templates: {}

        # process directory and build spritesheet
        build.processOne folder, params, (error, result) ->
          return cb(error) if error
          results[name] = result
          results[name].basename = basename
          grunt.log.writeln "created: #{name}"
          cb(null)

    # exec all handlers
    async.series process, (error) ->
      return done(false, error) if error

      # remove old spritesheets from result directory
      for old in oldSprites when not results[old]
        fs.unlinkSync old
        grunt.log.writeln "deleted: #{old}"

      # empty result
      if process.length <= 0
        return done(true)

      # generate template data
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

      # generate files from templates
      for name, out of options.templates
        try
          writeTemplate name, out, data, grunt
        catch e
          grunt.log.writeln e

      # save cache
      if options.cache
        fs.writeFileSync options.cacheFile, JSON.stringify(results, null, 2), 'utf8'
        grunt.log.writeln "cache saved: #{options.cacheFile}"

      return done(true)

  # register tasks
  grunt.registerMultiTask 'spriteBuilder' , 'Spritesheets packer', spriteBuilderMultiTask
  grunt.registerMultiTask 'sprite-builder', 'Spritesheets packer', spriteBuilderMultiTask
