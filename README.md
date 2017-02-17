# grunt-sprite-builder

Задача сборщика [`grunt`](http://gruntjs.com/), для упаковки спрайтов в атласы и вывода мета-данных результата. Для упаковки используется пакет [`ovcharik/sprite-builder`](https://github.com/ovcharik/sprite-builder).


## Установка

Так как пакет не размещен в [`npm`](https://www.npmjs.com/) репозитории, можно его поставить прямо из гитхаба. Для этого выболните следующую команду:

```bash
npm install --save-dev github:ovcharik/grunt-sprite-builder
```

Далее необходимо добавить задачу в Ваш `Gruntfile`:

```javascript
grunt.loadNpmTasks('grunt-sprite-builder');
```


## Использование

Задача называется `sprite-builder` (можно использовать и `spriteBuilder`). Параметры исходных данных, параметры результата и опции нужно задавать в соответствии с [руководством конфигурации задач](http://gruntjs.com/configuring-tasks) в `grunt`.


### Параметры исходных данных и параметры результата

Необходимо указывать путь до директории(ий), в которой(ых) лежат спрайты (параметр: `src`). Все спрайты из одной директории будут упакованы в один атлас. Результатом будет файл, имя которого складывается из имени директории со спрайтами и `md5` хэш-суммы, исходных файлов, если опция `hashname == true` (`<src-folder>-<md5-hash>.png`), иначе записывается просто имя дирректории. Файл будет сохранен в указанной директории (параметр: `dest`).

<details>
  <summary>
    <a href="#task-params-example-spoiler"><strong>Пример</strong></a>
  </summary>

```javascript
/*
 * Допустим у нас есть такое дерево файлов:
 * path/
 * └─ to/
 *    ├─ single-atlas/
 *    │  ├─ sprite-0.png
 *    │  ├─ sprite-1.png
 *    │  ├─ ...
 *    │  └─ sprite-n.png
 *    ├─ multi-atlases/
 *    │  ├─ multi-atlas-0/
 *    │  ├─ multi-atlas-1/
 *    │  ├─ ...
 *    │  └─ multi-atlas-n/
 *    └─ results/
 */

// Зададим параметры для задачи
grunt.initConfig({
  'sprite-builder': {
    'single-atlas': {
      src : 'path/to/single-atlas/',    // путь до директории со спрайтами
      dest: 'path/to/results/'          // путь до директории, куда сохранится результат
    },
    'multi-atlases': {
      src : 'path/to/multi-atlases/*/', // шаблон пути до директорий со спрайтами
      dest: 'path/to/results/'          // путь до директории, куда сохранится результат
    }
  }
});

/*
 * Результат выполнения обеих задач будет таким:
 * path/
 * └─ to/
 *    ├─ single-atlas/
 *    ├─ multi-atlases/
 *    └─ results/
 *       ├─ single-atlas-<md5-hash>.png
 *       ├─ multi-atlas-0-<md5-hash>.png
 *       ├─ multi-atlas-1-<md5-hash>.png
 *       ├─ ...
 *       └─ multi-atlas-n-<md5-hash>.png
 */
```
</details>

### Опции

<table>
  <thead>
    <tr>
      <th>Имя</th>
      <th>Свойства</th>
      <th>Описание</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong><code>method</code></strong></td>
      <td>
        Type:&nbsp;&nbsp;&nbsp;&nbsp;<code>("growing"|"vertival"|"horizontal")</code><br/>
        Default:&nbsp;<code>"growing"</code>
      </td>
      <td>
        <p>Метод упаковки спрайтов в атласы, доступны следующие:</p>
        <ul>
          <li><code>"growing"</code>- оптимальная площадь атласа (<a href="https://github.com/noyobo/img-spriter">алгоритм</a>);</li>
          <li><code>"vertical"</code> - в вертикальную линию;</li>
          <li><code>"horizontal"</code> - в горизонтальную линию.</li>
        </ul>
      </td>
    </tr>

    <tr>
      <td><strong><code>padding</code></strong></td>
      <td>
        Type:&nbsp;&nbsp;&nbsp;&nbsp;<code>Number</code><br/>
        Default:&nbsp;<code>0</code>
      </td>
      <td>Расстояние в пикселях между спрайтами в атласе.</td>
    </tr>

    <tr>
      <td><strong><code>trim</code></strong></td>
      <td>
        Type:&nbsp;&nbsp;&nbsp;&nbsp;<code>Boolean</code><br/>
        Default:&nbsp;<code>true</code>
      </td>
      <td>Обрезка пустых краев спрайтов.</td>
    </tr>

    <tr>
      <td><strong><code>hashname</code></strong></td>
      <td>
        Type:&nbsp;&nbsp;&nbsp;&nbsp;<code>Boolean</code><br/>
        Default:&nbsp;<code>true</code>
      </td>
      <td>Добавление к имени итогового атласа <code>md5</code> хэш-сумму.</td>
    </tr>

    <tr>
      <td><strong><code>cache</code></strong></td>
      <td>
        Type:&nbsp;&nbsp;&nbsp;&nbsp;<code>Boolean</code><br/>
        Default:&nbsp;<code>true</code>
      </td>
      <td>Кеширование промежуточного результата, позволяет ускорить выполнение задачи при повторных запусках.</td>
    </tr>

    <tr>
      <td><strong><code>cacheFile</code></strong></td>
      <td>
        Type:&nbsp;&nbsp;&nbsp;&nbsp;<code>String</code><br/>
        Default:&nbsp;<code>".sprite&#8209;builder&#8209;cache.json"</code>
      </td>
      <td>Файл для хранения кешированной информации.</td>
    </tr>

    <tr>
      <td><strong><code>filter</code></strong></td>
      <td>
        Type:&nbsp;&nbsp;&nbsp;&nbsp;<code>RegExp</code><br/>
        Default:&nbsp;<code>/\.png$/i</code>
      </td>
      <td>Фильтр для имени файлов спрайтов, которые будут упаковываться в атлас. Все файлы, что не соответсвуют фильтру будут игнорироваться.</td>
    </tr>

    <tr>
      <td><strong><code>templates</code></strong></td>
      <td>
        Type:&nbsp;&nbsp;&nbsp;&nbsp;<code>Object</code><br/>
        Default:&nbsp;<code>{}</code>
      </td>
      <td>
Шаблоны для записи мета-данных. <a href="#user-content-templates">Подробнее</a>.
      </td>
    </tr>
  </tbody>
</table>


<h3 id="templates">Шаблоны для записи мета-данных</h3>

Шаблоны указываются в обычном объекте, где ключ -- это название шаблона или путь до файла с шаблоном, а значние - это путь до файла, куда запишется результат. Шаблоны компилируются с помощью библиотеки [`mustache`](https://github.com/janl/mustache.js).


<details>
  <summary>
    <a href="#template-data-spoiler"><strong>Данные, передаваемые в шаблон</strong></a>
  </summary>

```javascript
{
  "files": [
    {
      "sprites": [
        {
          "name"         : "sprite-0", // имя образуется из базового имени файла

          "file"         : "path/to/atlas-0/sprite-0.png",   // путь до файла спрайта
          "dest"         : "path/to/atlas-0-<md5-hash>.png", // путь до атласа с этим спрайтом

          "width"        : 92,  // ширина обрезанного спрайта
          "height"       : 104, // высота обрезанного спрайта
          "offsetX"      : 2,   // x-координата верхнего левого угла спрайта с учетом padding'а
          "offsetY"      : 126, // y-координата верхнего левого угла спрайта с учетом padding'а

          "canvasX"      : 0,   // x-координата верхнего левого угла спрайта без учета padding'а
          "canvasY"      : 112, // y-координата верхнего левого угла спрайта без учета padding'а

          "frameWidth"   : 108, // оригинальная ширина спрайта
          "frameHeight"  : 140, // оригинальная высота спрайта
          "frameRegX"    : 2,   // x-координата верхнего левого спрайта до обрезки
          "frameRegY"    : 14,  // y-координата верхнего левого спрайта до обрезки

          "isFirst"      : true, // первый спрайт в списке
          "isLastSprite" : false // последний спрайт в списке
        }
        // [, <sprite-1> [, ...]]
      ],
      "basename"      : "atlas-0",          // базовое имя атласа
      "src"           : "path/to/atlas-0/", // путь до исходной директории со спрайтами
      "ext"           : ".png",             // расширение спрайтов

      "name"          : "path/to/atlas-0-<md5-hash>.png",   // путь до атласа
      "dest"          : "path/to/atlas-0-<md5-hash>.png",   // путь до атласа
      "hash"          : "62c0ab3a9443ca64848438d4c7fd219e", // md5-hash исходных файлов

      "width"         : 432, // ширина атласа
      "height"        : 280, // высота атласа
      "spritesLength" : 8,   // количество спрайтов в атласе

      "isLastFile"    : false // последний файл в списке
    }
    // [, <atlas-1> [, ...]]
  ]
}
```
</details>


<details>
  <summary>
    <a href="#template-data-spoiler"><strong>Заготовленные шаблоны</strong></a>
  </summary>

##### Шаблон `anim` ([код](templates/anim.template))

Создает файл формата `less`, в котором указанны переменные, описывающие параметры спрайтов, в дальнейшем эти переменные можно использовать для создания спрайтовой анимации на `less` используя `mixins`. Тут нужно учитывать, что данный шаблон используется для описания спрайтов упакованных в одну строку (`method = "horizontal"`), что бы в дальнейшем можно было написать миксин для "проматывания" итогового атласа, и создания тем самым спрайтовой анимации. Формат:

```less
@sprite-0_url     : "./path/to/atlas-0-<md5-hash>.png";
@sprite-0_w       : 1024px; // ширина атласа
@sprite-0_h       : 128px;  // высота атласа
@sprite-0_frames  : 8;      // количество спрайтов в атласе
@sprite-0_frame_w : 128px;  // ширина одного спрайта
@sprite-0_frame_h : 128px;  // высота одного спрайта

// [<sprite-1> [...]]
```

##### Шаблон `json` ([код](templates/json.template))

В `json` шаблон записывается необходимая информация о спрайтах. Формат:

```javascript
{
  "./path/to/atlas-0-<md5-hash>.png": {
    "sprite-0": { // имя спрайта (базовое имя файла)
      "w" : 128,  // ширина (px) спрайта
      "h" : 128,  // высота (px) спрайта
      "x" : 0,    // x-координата (px) верхнего левого угла спрайта в атласе
      "y" : 0     // y-координата (px) верхнего левого угла спрайта в атласе
    },
    // [, <sprite-1> [, ...]]
  },
  // [, <atlas-1> [, ...]]
}
```

##### Шаблон `less` ([код](templates/less.template))

В `less` шаблон записывается необходимая информация о спрайтах в виде переменных. Формат:

```less
// atlas-0
@sprite-0_f: "./path/to/atlas-0-<md5-hash>.png";
@sprite-0_w: 128px; // ширина спрайта
@sprite-0_h: 128px; // высота спрайта
@sprite-0_x: -0px;  // -x-координата верхнего левого угла спрайта в атласе
@sprite-0_y: -0px;  // -y-координата верхнего левого угла спрайта в атласе

// [<sprite-1> [...]]
```
</details>


## [Пример использования](example/)
