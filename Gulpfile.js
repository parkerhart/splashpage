var gulp = require('gulp'),
    gutil = require('gulp-util'),
    less = require('gulp-less'),
    cssmin = require('gulp-cssmin'),
    coffee = require('gulp-coffee'),
    uglify = require('gulp-uglify'),
    concat = require('gulp-concat');

var base = 'pages/',
    assets = 'components/',
    buildBase = 'build/',
    libPath = assets + 'lib/*';
    lessPath = assets + 'less/*.less',
    coffeePath = assets + 'coffee/*.coffee';

function lessTasks() {
  gulp.src(lessPath)
  .pipe( less( {sourceMap : true} ) )
  .pipe( cssmin() )
  .pipe( gulp.dest( buildBase + 'css' ) );
}

function coffeeTasks() {
  gulp.src(coffeePath)
  .pipe( coffee( {bare : true} ).on('error', gutil.log) )
  .pipe( uglify() )
  .pipe( gulp.dest( buildBase + 'js' ) );
}

function moveTask() {
  gulp.src(base + '*.html')
  .pipe( gulp.dest( buildBase) );

  gulp.src(libPath)
  .pipe( gulp.dest( buildBase + 'lib') );

  gulp.src(assets + 'images/logos/' + '*')
  .pipe( gulp.dest( buildBase + 'images/logos') );

  gulp.src(assets + 'images/features/' + '*')
  .pipe( gulp.dest( buildBase + 'images/features') );

  gulp.src(assets + 'images/icons/' + '*')
  .pipe( gulp.dest( buildBase + 'images/icons') );

  gulp.src(assets + 'images/success-image/' + '*')
  .pipe( gulp.dest( buildBase + 'images/success-image') );
}

gulp.task('less', lessTasks);
gulp.task('coffee', coffeeTasks);
gulp.task('move', moveTask);
gulp.task('build', ['less', 'coffee', 'move']);
