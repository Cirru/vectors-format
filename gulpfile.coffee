
gulp = require 'gulp'
coffee = require 'gulp-coffee'

gulp.task 'coffee', ->
  gulp.src('src/*')
  .pipe coffee(bare: yes)
  .pipe gulp.dest('lib/')
