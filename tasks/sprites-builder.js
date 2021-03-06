// Generated by CoffeeScript 1.12.3
(function() {
  var Mustache, _, async, build, defaultOptions, defaultTemplates, fs, md5, path, slash, spritesFolderHash, writeTemplate;

  _ = require('underscore');

  fs = require('fs');

  md5 = require('md5');

  path = require('path');

  async = require('async');

  slash = require('slash');

  build = require('sprite-builder');

  Mustache = require('mustache');

  defaultOptions = {
    method: 'growing',
    padding: 0,
    trim: true,
    hashname: true,
    cache: true,
    cacheFile: ".sprite-builder-cache.json",
    filter: /\.png$/i,
    templates: {}
  };

  defaultTemplates = {
    'json': path.resolve(__dirname, '..', 'templates', 'json.template'),
    'less': path.resolve(__dirname, '..', 'templates', 'less.template'),
    'anim': path.resolve(__dirname, '..', 'templates', 'anim.template')
  };

  spritesFolderHash = function(src) {
    var buffer, file, files, k, len, p, s;
    buffer = "";
    files = fs.readdirSync(src);
    for (k = 0, len = files.length; k < len; k++) {
      file = files[k];
      p = path.join(src, file);
      s = fs.statSync(p);
      buffer += "" + (slash(p)) + (s.mtime.valueOf()) + s.size;
    }
    return md5(buffer);
  };

  writeTemplate = function(input, output, data, grunt) {
    var ref, result, template, templatePath;
    templatePath = (ref = defaultTemplates[input]) != null ? ref : input;
    template = fs.readFileSync(templatePath, 'utf8');
    result = Mustache.render(template, data);
    fs.writeFileSync(output, result, 'utf8');
    return grunt.log.writeln("created: " + output);
  };

  module.exports = function(grunt) {
    var spriteBuilderMultiTask;
    spriteBuilderMultiTask = function() {
      var cacheData, dest, done, e, folders, oldSprites, options, process, results;
      done = this.async();
      options = this.options(defaultOptions);
      dest = this.data.dest;
      folders = _(this.files).reduce((function(memo, file) {
        return memo.concat(file.src);
      }), []);
      try {
        oldSprites = _(fs.readdirSync(dest)).map(function(file) {
          return path.join(dest, file);
        });
      } catch (error1) {
        e = error1;
        grunt.log.error(e);
        oldSprites = [];
      }
      if (options.cache) {
        try {
          cacheData = grunt.file.readJSON(options.cacheFile);
        } catch (error1) {
          e = error1;
          cacheData = {};
        }
      } else {
        cacheData = {};
      }
      process = [];
      results = {};
      _(folders).each(function(folder) {
        var basename, name;
        basename = path.basename(folder);
        name = options.hashname ? path.join(dest, basename + "-" + (spritesFolderHash(folder)) + ".png") : path.join(dest, basename + ".png");
        if (_(oldSprites).include(name) && cacheData[name]) {
          results[name] = cacheData[name];
          return;
        }
        return process.push(function(cb) {
          var params;
          params = {
            dest: name,
            method: options.method,
            padding: options.padding,
            trim: options.trim,
            filter: options.filter,
            templates: {}
          };
          return build.processOne(folder, params, function(error, result) {
            if (error) {
              return cb(error);
            }
            results[name] = result;
            results[name].basename = basename;
            grunt.log.writeln("created: " + name);
            return cb(null);
          });
        });
      });
      return async.series(process, function(error) {
        var data, file, fkey, fkeys, i, k, l, len, len1, name, old, out, ref;
        if (error) {
          return done(false, error);
        }
        for (k = 0, len = oldSprites.length; k < len; k++) {
          old = oldSprites[k];
          if (!(!results[old])) {
            continue;
          }
          fs.unlinkSync(old);
          grunt.log.writeln("deleted: " + old);
        }
        if (process.length <= 0) {
          return done(true);
        }
        data = {
          files: []
        };
        fkeys = _.chain(results).keys().sortBy().value();
        for (i = l = 0, len1 = fkeys.length; l < len1; i = ++l) {
          fkey = fkeys[i];
          file = results[fkey];
          file.dest = slash(file.dest);
          file.isLastFile = i === (fkeys.length - 1);
          file.name = fkey;
          file.spritesLength = file.sprites.length;
          data.files.push(file);
          file.sprites = _(file.sprites).sortBy('name');
          _(file.sprites).each(function(s, j) {
            s.dest = file.dest;
            return s.isLastSprite = j === file.sprites.length - 1;
          });
        }
        ref = options.templates;
        for (name in ref) {
          out = ref[name];
          try {
            writeTemplate(name, out, data, grunt);
          } catch (error1) {
            e = error1;
            grunt.log.writeln(e);
          }
        }
        if (options.cache) {
          fs.writeFileSync(options.cacheFile, JSON.stringify(results, null, 2), 'utf8');
          grunt.log.writeln("cache saved: " + options.cacheFile);
        }
        return done(true);
      });
    };
    grunt.registerMultiTask('spriteBuilder', 'Spritesheets packer', spriteBuilderMultiTask);
    return grunt.registerMultiTask('sprite-builder', 'Spritesheets packer', spriteBuilderMultiTask);
  };

}).call(this);
