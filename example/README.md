# example

## Структура примера

```text
example/
├─ Gruntfile.js
├─ sprites/
│   ├─ backward/
│   │  ├─ backward-0.png
│   │  ├─ backward-1.png
│   │  ├─ backward-2.png
│   │  ├─ backward-3.png
│   │  ├─ backward-4.png
│   │  ├─ backward-5.png
│   │  ├─ backward-6.png
│   │  └─ backward-7.png
│   └─ forward/
│       ├─ forward-0.png
│       ├─ forward-1.png
│       ├─ forward-2.png
│       ├─ forward-3.png
│       ├─ forward-4.png
│       ├─ forward-5.png
│       ├─ forward-6.png
│       └─ forward-7.png
└─ result/
   ├─ growing/
   │  ├─ backward.png
   │  └─ forward.png
   ├─ horizontal/
   │  ├─ backward.png
   │  └─ forward.png
   ├─ growing-json.json
   ├─ growing-less.less
   └─ horizontal-anim.less
```


## [`Gruntfile.js`](Gruntfile.js)

```javascript
module.exports = function(grunt) {
  grunt.loadNpmTasks('grunt-sprite-builder');

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
```

## Исходные изображения

### [sprites/backward](sprites/backward)

| Название | Изображение | Название | Изображение |
| -------- | ----------- | -------- | ----------- |
| [backward-0.png](sprites/backward/backward-0.png) | ![backward-0.png](https://raw.githubusercontent.com/ovcharik/grunt-sprite-builder/master/example/sprites/backward/backward-0.png) | [backward-1.png](sprites/backward/backward-1.png) | ![backward-1.png](https://raw.githubusercontent.com/ovcharik/grunt-sprite-builder/master/example/sprites/backward/backward-1.png) |
| [backward-2.png](sprites/backward/backward-2.png) | ![backward-2.png](https://raw.githubusercontent.com/ovcharik/grunt-sprite-builder/master/example/sprites/backward/backward-2.png) | [backward-3.png](sprites/backward/backward-3.png) | ![backward-3.png](https://raw.githubusercontent.com/ovcharik/grunt-sprite-builder/master/example/sprites/backward/backward-3.png) |
| [backward-4.png](sprites/backward/backward-4.png) | ![backward-4.png](https://raw.githubusercontent.com/ovcharik/grunt-sprite-builder/master/example/sprites/backward/backward-4.png) | [backward-5.png](sprites/backward/backward-5.png) | ![backward-5.png](https://raw.githubusercontent.com/ovcharik/grunt-sprite-builder/master/example/sprites/backward/backward-5.png) |
| [backward-6.png](sprites/backward/backward-6.png) | ![backward-6.png](https://raw.githubusercontent.com/ovcharik/grunt-sprite-builder/master/example/sprites/backward/backward-6.png) | [backward-7.png](sprites/backward/backward-7.png) | ![backward-7.png](https://raw.githubusercontent.com/ovcharik/grunt-sprite-builder/master/example/sprites/backward/backward-7.png) |

### [sprites/forward](sprites/forward)

| Название | Изображение | Название | Изображение |
| -------- | ----------- | -------- | ----------- |
| [forward-0.png](sprites/forward/forward-0.png) | ![forward-0.png](https://raw.githubusercontent.com/ovcharik/grunt-sprite-builder/master/example/sprites/forward/forward-0.png) | [forward-1.png](sprites/forward/forward-1.png) | ![forward-1.png](https://raw.githubusercontent.com/ovcharik/grunt-sprite-builder/master/example/sprites/forward/forward-1.png) |
| [forward-2.png](sprites/forward/forward-2.png) | ![forward-2.png](https://raw.githubusercontent.com/ovcharik/grunt-sprite-builder/master/example/sprites/forward/forward-2.png) | [forward-3.png](sprites/forward/forward-3.png) | ![forward-3.png](https://raw.githubusercontent.com/ovcharik/grunt-sprite-builder/master/example/sprites/forward/forward-3.png) |
| [forward-4.png](sprites/forward/forward-4.png) | ![forward-4.png](https://raw.githubusercontent.com/ovcharik/grunt-sprite-builder/master/example/sprites/forward/forward-4.png) | [forward-5.png](sprites/forward/forward-5.png) | ![forward-5.png](https://raw.githubusercontent.com/ovcharik/grunt-sprite-builder/master/example/sprites/forward/forward-5.png) |
| [forward-6.png](sprites/forward/forward-6.png) | ![forward-6.png](https://raw.githubusercontent.com/ovcharik/grunt-sprite-builder/master/example/sprites/forward/forward-6.png) | [forward-7.png](sprites/forward/forward-7.png) | ![forward-7.png](https://raw.githubusercontent.com/ovcharik/grunt-sprite-builder/master/example/sprites/forward/forward-7.png) |


## Результаты

### Метод `growing`

#### `result/growing/backward.png`
![backward.png](https://raw.githubusercontent.com/ovcharik/grunt-sprite-builder/master/example/result/growing/backward.png)


#### `result/growing/forward.png`
![forward.png](https://raw.githubusercontent.com/ovcharik/grunt-sprite-builder/master/example/result/growing/forward.png)


### Метод `horizontal` без обрезания краев

#### `result/horizontal/backward.png`
![backward.png](https://raw.githubusercontent.com/ovcharik/grunt-sprite-builder/master/example/result/horizontal/backward.png)


#### `result/horizontal/forward.png`
![forward.png](https://raw.githubusercontent.com/ovcharik/grunt-sprite-builder/master/example/result/horizontal/forward.png)
