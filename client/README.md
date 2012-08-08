Vasir Tactics (name in progress)
=================================
Dependencies:
    node (http://nodejs.org/)
        npm (http://npmjs.org/)


Steps
=====
First, you'll need to make sure all the dependencies are installed. Make sure Node and NPM are installed
Then, setup node dependencies by running this in the root directory (directory this README is in):
    npm install -d


Then, compile all the files. To make everything (except third party)
make

Then compile third party files
make third


Whenever you edit a coffee file, run make to recompile and minify everything
    -note: you can run 
        make watch
        and it will watch your coffeescript files, but this require Ruby and watchr


-------
After everything is compiled, start up a simple HTTP server in this root directory:
    python -m SimpleHTTPServer 8000

Then go to in your browser
    http://localhost:8000/
