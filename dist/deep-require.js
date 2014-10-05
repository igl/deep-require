// Generated by LiveScript 1.3.0
'use strict';
var fs, path, defaults, camelize, filter, deepRequire;
fs = require('fs');
path = require('path');
defaults = {
  extensions: ['js', 'json', 'ls', 'coffee'],
  recursive: false,
  camelize: true,
  filter: null,
  map: null
};
camelize = function(str){
  return str.replace(/[-_]+(.)?/g, function(arg$, c){
    return (c != null ? c : '').toUpperCase();
  });
};
filter = function(method, name){
  switch (Object.prototype.toString.call(method).slice(8, -1)) {
  case 'Function':
    return method(name);
  case 'RegExp':
    return method.test(name);
  default:
    return true;
  }
};
deepRequire = module.exports = curry$(function(cwd, opts, root){
  var options, k, ref$, v, parseDir;
  options = {};
  for (k in ref$ = defaults) {
    v = ref$[k];
    options[k] = v;
  }
  for (k in opts) {
    v = opts[k];
    options[k] = v;
  }
  parseDir = function(dir){
    var modules, absDir;
    modules = {};
    absDir = path.join(cwd, dir);
    fs.readdirSync(absDir).forEach(function(name){
      var ext, relPath, absPath, stat;
      ext = name.match(/\.(.*)$/i) || [];
      relPath = path.join(dir, name);
      absPath = path.join(cwd, relPath);
      stat = fs.statSync(absPath);
      name = name.replace(ext[0], '');
      if (options.camelize) {
        name = camelize(name);
      }
      if (options.map) {
        name = options.map(name);
      }
      if (stat.isDirectory() && options.recursive) {
        return modules[name] = parseDir(relPath);
      } else if (stat.isFile() && options.extensions.indexOf(ext[1]) !== -1) {
        if (!filter(options.filter, name)) {
          return;
        }
        return modules[name] = require(absPath);
      }
    });
    return modules;
  };
  return parseDir(root);
});
function curry$(f, bound){
  var context,
  _curry = function(args) {
    return f.length > 1 ? function(){
      var params = args ? args.concat() : [];
      context = bound ? context || this : this;
      return params.push.apply(params, arguments) <
          f.length && arguments.length ?
        _curry.call(context, params) : f.apply(context, params);
    } : f;
  };
  return _curry();
}