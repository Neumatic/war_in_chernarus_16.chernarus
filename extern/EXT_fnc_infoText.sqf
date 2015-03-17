//	File: infoText.sqf
//	Author: Karel Moricky
// 	Reworked by code34 for warcontext
// 	Description: Info with some effects.

private [
	"_text", "_logs", "_count", "_textArrayUnicode", "_textArrayLines", "_line", "_textArrayTemp", "_textArray", "_emptyArray",
	"_nArrayTemp", "_n", "_finalArray", "_nArray", "_element", "_display", "_textControl"
];

// Array of info text
_text = _this;

while {!wccanwriteinfotext} do {sleep 1};
wccanwriteinfotext = false;

10200 cutRsc ["infomission","PLAIN"];

// Add info text to warcontext logs
_logs = "";
_count = (count wcclientlogs) - 1;
{
	if (wcclientlogs select _count != format ["%1", _x]) then {
		_logs = _logs + " " + format ["%1", _x];
	};
} forEach _text;
wcclientlogs set [count wcclientlogs, _logs];

_textArrayUnicode = [];
{_textArrayUnicode set [count _textArrayUnicode, toArray _x]} forEach _text;

// Separate letters
_textArrayLines = [];
for "_i" from 0 to (count _textArrayUnicode - 1) do {
	_line = _textArrayUnicode select _i;
	_textArrayTemp = [];
	{_textArrayTemp set [count _textArrayTemp, toString [_x]]} forEach _line;
	_textArrayLines set [_i, _textArrayTemp];
};

// Merge arrays
_textArray = [];
_emptyArray = [];
_nArrayTemp = [];
_n = 0;
{
	_line = _x;
	_textArray set [count _textArray, _line + ["\n"]];
	{
		_emptyArray set [count _emptyArray, " "]; // Space
		_nArrayTemp set [count _nArrayTemp, _n];
		_n = _n + 1;
	} forEach _x;
	_n = _n + 1;
	_emptyArray set [count _emptyArray, "\n"];
} forEach _textArrayLines;
_finalArray = _emptyArray;
_text = composeText _finalArray;

// Random order
_nArray = [];
while {count _nArrayTemp > 0} do {
	_element = _nArrayTemp select (floor random (count _nArrayTemp));
	_nArray set [count _nArray, _element];
	_nArrayTemp = _nArrayTemp - [_element];
};

// Visualization
disableSerialization;
_display = uiNamespace getVariable ["wcinfomissiondisplay", objNull];
//_textControl = _display displayCtrl 3101;
_textControl = _display displayCtrl 10201;

_text = composeText _finalArray;
_textControl ctrlSetText str _text;
_textControl ctrlSetFontHeight 0.04;
_textControl ctrlCommit 0.01;

//{
//	_finalArray set [_x,_textArray select _x];
//	_text = composeText _finalArray;
//	_textControl ctrlSetText str _text;
//	_textControl ctrlCommit 0.01;
//	sleep 0.01;
//} forEach _nArray;

_text = "";
{
	{
		_text = _text + _x;
		_textControl ctrlSetText (_text + "|");
		_textControl ctrlCommit 0.01;
		sleep 0.05;
	} forEach _x;
	_textControl ctrlSetText _text;
	_textControl ctrlCommit 0.01;
	sleep 0.05;
	_text = _text + "\n";
} forEach _textArrayLines;

sleep 8;

// Fade away
//{
//	_finalArray set [_x, " "];
//	_text = composeText _finalArray;
//	_textControl ctrlSetText str _text;
//	_textControl ctrlCommit 0.01;
//	sleep 0.01;
//} forEach _nArray;

10200 cutText ["","plain"];

wccanwriteinfotext = true;
