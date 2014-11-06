# install
* `npm install`

# run test
* `npm test` or `karma start`

# gulp command
* `gulp`
  * webserver起動後、scriptの変更、imgの変更を監視してtaskを走らせる
  * http://localhost:9999/index.html
  * 個々のtaskに関しては `gulpfile.coffee` を参照されたい

# directory
##### （かいつまんで補足）

* `src/` 開発時にいじるものをまとめてぶち込む（imgとか入ってるのはドンマイ）
  * `map/` coffeeとjsを対応付けるソースマップ置き場
  * `coffee/` coffeeを書きたい人はここにどーぞ
  * `js/` バニラJSを書きたい人はここにどーぞ（coffeeをcompileするとここに吐き出す）
  * `test/` テストファイル置き場

* `dist/` `gulp convert` が走ると生成されるディレクトリ。production向け
  * `concat/` uglify + concat されたJSファイルが入る
  * `js/` uglify されたJSファイルが入る
