// Load asciidoctor.js and asciidoctor-reveal.js
var asciidoctor = require('asciidoctor.js')();
var asciidoctorRevealJS = require('asciidoctor-reveal.js');
asciidoctorRevealJS.register()

// Convert the document 'presentation.adoc' using the reveal.js converter
var args = process.argv.slice(2)  // Cut the first two argv, start at argv[2]
var options = {backend: 'revealjs', to_file: args[1]};
asciidoctor.convertFile(args[0], options);
