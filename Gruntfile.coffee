module.exports = (grunt) ->
  
  grunt.initConfig
    pkg: grunt.file.readJSON "package.json"
    coffee:
      app:
        src: "coffee/**/*.coffee"
        dest: "js/app.js"
    stylus:
      app:
        src: "styl/**/*.styl"
        dest: "css/style.css"
    jst:
      compile:
        options:
          processName: (filename) ->
            filename = filename.replace /\.[a-z0-9]+$/i, ""
            filename.substring filename.lastIndexOf("/")+1
        files:
          "js/templates.js": ["templates/**/*.ejs"]
    watch:
      coffee:
        files: "coffee/**/*.coffee"
        tasks: ["coffee"]
      stylus:
        files: "styl/**/*.styl"
        tasks: ["stylus"]
      jst:
        files: "templates/**/*"
        tasks: ["jst"]
  
  grunt.registerTask "default", ["coffee", "stylus", "jst"]
  
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-stylus"
  grunt.loadNpmTasks "grunt-contrib-jst"
  grunt.loadNpmTasks "grunt-contrib-watch"
  #grunt.loadNpmTasks "grunt-newer"
