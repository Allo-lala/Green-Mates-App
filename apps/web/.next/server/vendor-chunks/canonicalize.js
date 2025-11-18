"use strict";
/*
 * ATTENTION: An "eval-source-map" devtool has been used.
 * This devtool is neither made for production nor for readable output files.
 * It uses "eval()" calls to create a separate source file with attached SourceMaps in the browser devtools.
 * If you are trying to read the output file, select a different devtool (https://webpack.js.org/configuration/devtool/)
 * or disable the default devtool with "devtool: false".
 * If you are looking for production-ready output files, see mode: "production" (https://webpack.js.org/configuration/mode/).
 */
exports.id = "vendor-chunks/canonicalize";
exports.ids = ["vendor-chunks/canonicalize"];
exports.modules = {

/***/ "(ssr)/./node_modules/canonicalize/lib/canonicalize.js":
/*!*******************************************************!*\
  !*** ./node_modules/canonicalize/lib/canonicalize.js ***!
  \*******************************************************/
/***/ ((module) => {

eval("/* jshint esversion: 6 */\n/* jslint node: true */\n\n\nmodule.exports = function serialize (object) {\n  if (typeof object === 'number' && isNaN(object)) {\n    throw new Error('NaN is not allowed');\n  }\n\n  if (typeof object === 'number' && !isFinite(object)) {\n    throw new Error('Infinity is not allowed');\n  }\n\n  if (object === null || typeof object !== 'object') {\n    return JSON.stringify(object);\n  }\n\n  if (object.toJSON instanceof Function) {\n    return serialize(object.toJSON());\n  }\n\n  if (Array.isArray(object)) {\n    const values = object.reduce((t, cv, ci) => {\n      const comma = ci === 0 ? '' : ',';\n      const value = cv === undefined || typeof cv === 'symbol' ? null : cv;\n      return `${t}${comma}${serialize(value)}`;\n    }, '');\n    return `[${values}]`;\n  }\n\n  const values = Object.keys(object).sort().reduce((t, cv) => {\n    if (object[cv] === undefined ||\n        typeof object[cv] === 'symbol') {\n      return t;\n    }\n    const comma = t.length === 0 ? '' : ',';\n    return `${t}${comma}${serialize(cv)}:${serialize(object[cv])}`;\n  }, '');\n  return `{${values}}`;\n};\n//# sourceURL=[module]\n//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiKHNzcikvLi9ub2RlX21vZHVsZXMvY2Fub25pY2FsaXplL2xpYi9jYW5vbmljYWxpemUuanMiLCJtYXBwaW5ncyI6IkFBQUE7QUFDQTtBQUNhOztBQUViO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsZ0JBQWdCLEVBQUUsRUFBRSxNQUFNLEVBQUUsaUJBQWlCO0FBQzdDLEtBQUs7QUFDTCxlQUFlLE9BQU87QUFDdEI7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsY0FBYyxFQUFFLEVBQUUsTUFBTSxFQUFFLGNBQWMsR0FBRyxzQkFBc0I7QUFDakUsR0FBRztBQUNILFdBQVcsRUFBRSxRQUFRO0FBQ3JCIiwic291cmNlcyI6WyJ3ZWJwYWNrOi8vZ3Jpbi1tYXRlcy8uL25vZGVfbW9kdWxlcy9jYW5vbmljYWxpemUvbGliL2Nhbm9uaWNhbGl6ZS5qcz8wYzEzIl0sInNvdXJjZXNDb250ZW50IjpbIi8qIGpzaGludCBlc3ZlcnNpb246IDYgKi9cbi8qIGpzbGludCBub2RlOiB0cnVlICovXG4ndXNlIHN0cmljdCc7XG5cbm1vZHVsZS5leHBvcnRzID0gZnVuY3Rpb24gc2VyaWFsaXplIChvYmplY3QpIHtcbiAgaWYgKHR5cGVvZiBvYmplY3QgPT09ICdudW1iZXInICYmIGlzTmFOKG9iamVjdCkpIHtcbiAgICB0aHJvdyBuZXcgRXJyb3IoJ05hTiBpcyBub3QgYWxsb3dlZCcpO1xuICB9XG5cbiAgaWYgKHR5cGVvZiBvYmplY3QgPT09ICdudW1iZXInICYmICFpc0Zpbml0ZShvYmplY3QpKSB7XG4gICAgdGhyb3cgbmV3IEVycm9yKCdJbmZpbml0eSBpcyBub3QgYWxsb3dlZCcpO1xuICB9XG5cbiAgaWYgKG9iamVjdCA9PT0gbnVsbCB8fCB0eXBlb2Ygb2JqZWN0ICE9PSAnb2JqZWN0Jykge1xuICAgIHJldHVybiBKU09OLnN0cmluZ2lmeShvYmplY3QpO1xuICB9XG5cbiAgaWYgKG9iamVjdC50b0pTT04gaW5zdGFuY2VvZiBGdW5jdGlvbikge1xuICAgIHJldHVybiBzZXJpYWxpemUob2JqZWN0LnRvSlNPTigpKTtcbiAgfVxuXG4gIGlmIChBcnJheS5pc0FycmF5KG9iamVjdCkpIHtcbiAgICBjb25zdCB2YWx1ZXMgPSBvYmplY3QucmVkdWNlKCh0LCBjdiwgY2kpID0+IHtcbiAgICAgIGNvbnN0IGNvbW1hID0gY2kgPT09IDAgPyAnJyA6ICcsJztcbiAgICAgIGNvbnN0IHZhbHVlID0gY3YgPT09IHVuZGVmaW5lZCB8fCB0eXBlb2YgY3YgPT09ICdzeW1ib2wnID8gbnVsbCA6IGN2O1xuICAgICAgcmV0dXJuIGAke3R9JHtjb21tYX0ke3NlcmlhbGl6ZSh2YWx1ZSl9YDtcbiAgICB9LCAnJyk7XG4gICAgcmV0dXJuIGBbJHt2YWx1ZXN9XWA7XG4gIH1cblxuICBjb25zdCB2YWx1ZXMgPSBPYmplY3Qua2V5cyhvYmplY3QpLnNvcnQoKS5yZWR1Y2UoKHQsIGN2KSA9PiB7XG4gICAgaWYgKG9iamVjdFtjdl0gPT09IHVuZGVmaW5lZCB8fFxuICAgICAgICB0eXBlb2Ygb2JqZWN0W2N2XSA9PT0gJ3N5bWJvbCcpIHtcbiAgICAgIHJldHVybiB0O1xuICAgIH1cbiAgICBjb25zdCBjb21tYSA9IHQubGVuZ3RoID09PSAwID8gJycgOiAnLCc7XG4gICAgcmV0dXJuIGAke3R9JHtjb21tYX0ke3NlcmlhbGl6ZShjdil9OiR7c2VyaWFsaXplKG9iamVjdFtjdl0pfWA7XG4gIH0sICcnKTtcbiAgcmV0dXJuIGB7JHt2YWx1ZXN9fWA7XG59O1xuIl0sIm5hbWVzIjpbXSwic291cmNlUm9vdCI6IiJ9\n//# sourceURL=webpack-internal:///(ssr)/./node_modules/canonicalize/lib/canonicalize.js\n");

/***/ })

};
;