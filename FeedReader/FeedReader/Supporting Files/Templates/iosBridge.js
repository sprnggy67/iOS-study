/*
 This file contains a set of functions to bridge the gap between javascript and iOS
 */

var oldConsole = console;

function openCustomURLinIFrame(src)
{
    var iframe = document.createElement("IFRAME");
    iframe.setAttribute("src",src);
    // For some reason we need to set a non-empty size for the iOS6 simulator...
    iframe.setAttribute("height", "1px");
    iframe.setAttribute("width", "1px");
    document.documentElement.appendChild(iframe);
    iframe.parentNode.removeChild(iframe);
    iframe = null;
}

function calliOSFunction(functionName, args, successCallback, errorCallback)
{
    var url = "js2ios://";
    
    var callInfo = {};
    callInfo.functionname = functionName;
    if (successCallback)
    {
        callInfo.success = successCallback;
    }
    if (errorCallback)
    {
        callInfo.error = errorCallback;
    }
    if (args)
    {
        callInfo.args = args;
    }
    
    url += JSON.stringify(callInfo)
    
    openCustomURLinIFrame(url);
}

console = new Object();

console.log = function(log) {
    oldConsole.log(log);
    calliOSFunction("log", log);
}

console.debug = function(log) {
    oldConsole.debug(log);
    calliOSFunction("log", "debug:" + log);
}

console.info = function(log) {
    oldConsole.info(log);
    calliOSFunction("log", "info:" + log);
}

console.warn = function(log) {
    oldConsole.warn(log);
    calliOSFunction("log", "warn:" + log);
}

console.error = function(log) {
    oldConsole.error(log);
    calliOSFunction("log", "error:" + log);
}

console.time = function(label) {
    oldConsole.time(label);
    calliOSFunction("time", label);
}

console.timeEnd = function(label) {
    oldConsole.timeEnd(label);
    calliOSFunction("timeEnd", label);
}

console.log("Started iOS logger");
