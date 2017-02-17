module.exports = function(grunt) {
  require('../src/sprites-builder')(grunt);

  grunt.initConfig({
    'sprite-builder': {
      growing: {
        options: {
          method   : 'growing',
          hashname : false,
          cache    : true,
          cacheFile: '.growing-cache.json',
          templates: {
            json: './result/growing-json.json',
            less: './result/growing-less.less'
          }
        },
        src : './sprites/*/',
        dest: './result/growing/'
      },
      horizontal: {
        options: {
          method   : 'horizontal',
          trim     : false,
          hashname : false,
          cache    : true,
          cacheFile: '.horizontal-cache.json',
          templates: {
            anim: './result/horizontal-anim.less'
          }
        },
        src : './sprites/*/',
        dest: './result/horizontal/'
      }
    }
  });
};
