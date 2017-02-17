module.exports = function(grunt) {
  require('../src/sprites-builder')(grunt);

  grunt.initConfig({
    'sprite-builder': {
      growing: {
        options: {
          method   : 'growing',
          cache    : false,
          hashname : false,
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
          cache    : false,
          hashname : false,
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
