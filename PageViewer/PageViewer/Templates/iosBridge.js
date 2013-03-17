/*
 This file contains a set of functions to bridge the gap between javascript and iOS
 */

function openCustomURLinIFrame(src)
{
    var rootElm = document.documentElement;
    var newFrameElm = document.createElement("IFRAME");
    newFrameElm.setAttribute("src",src);
    rootElm.appendChild(newFrameElm);
    newFrameElm.parentNode.removeChild(newFrameElm);
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
    calliOSFunction("log", log);
}

console.debug = console.log;
console.info = console.log;
console.warn = console.log;
console.error = console.log;

console.time = function(label) {
    console.log("time:" + label);
}

console.timeEnd = function(label) {
    console.log("timeEnd:" + label);
}
