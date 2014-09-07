# time-eventloop [![Build Status](https://secure.travis-ci.org/kirstein/time-eventloop.png?branch=master)](https://travis-ci.org/kirstein/time-eventloop)

> notify when eventloop ticks are getting delayed

### What?

A small utility that helps you analyze the state of your amazing event loop.
Will notify you when your event loop has become slower than a certain threshold.

### Getting started

`npm install time-eventloop`

### Examples

#### Usage: 
```javascript
var timeEventLoop = require('time-eventloop');
timeEventLoop.start(/* { options } */);
```

#### Options:
_All options are optional. Default values can be seen from [here](https://github.com/kirstein/time-eventloop/blob/master/src/time-eventloop.coffee#L46-L56)_

__interval__ - (ms) timeloop delay checking interval  
__factor__ - constant used to evaluate the differences between real and expected times  
__color__ - warning colors according to the delay range  

### Testing 

watches for file changes and reruns tests each time
```bash
grunt watch 
```

runs spec tests   
```bash
grunt test  
```

produces coverage report
```bash
grunt cov   
```

## License

MIT
