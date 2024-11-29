//might should go somewhere else as not tied to timer anymore?
class timer_RscFrame {
	type = CT_STATIC;
	idc = -1;
	shadow = 1;
	colorBackground[] = {0,0,0,0};
	colorText[] = {0.6,0.6,0.6,1};  
	style = 64;
	//w = 0.055583;
	//h = 0.039221;
	font = "puristaMedium";
	//borderSize = 0.1;
	sizeEx = 0.045;
	text = "";
}

class timer_RscText
{
  access = 0;
  idc = -1;
  type = CT_STATIC;
  style = ST_CENTER;
  linespacing = 1;
  colorBackground[] = {0,0,0,0};
  colorText[] = {1,0.1,0.1,1};
  text = "";
  shadow = 2;
  font = "puristaMedium";
  SizeEx = 0.08;
  fixedWidth = 0;
  x = 0;
  y = 0;
  h = 0;
  w = 0; 
};

class rambo_RscFrame {
	type = CT_STATIC;
	idc = -1;
	shadow = 1;
	colorBackground[] = {0,0,0,0};
	colorText[] = {0.6,0.6,0.6,1};  
	style = 64;
	//w = 0.055583;
	//h = 0.039221;
	font = "puristaMedium";
	//borderSize = 0.1;
	sizeEx = 0.045;
	text = "";
}

class rambo_RscText
{
  access = 0;
  idc = -1;
  type = CT_STATIC;
  style = ST_CENTER;
  linespacing = 1;
  colorBackground[] = {0,0,0,0};
  colorText[] = {1,0.1,0.1,1};
  text = "";
  shadow = 2;
  font = "puristaMedium";
  SizeEx = 0.04;
  fixedWidth = 0;
  x = 0;
  y = 0;
  h = 0;
  w = 0; 
};


class RscTitles
{
	class timerClass
	{
		idd = 1320;
		name = "Timer";
		movingEnable = false;
		enableSimulation = true;
		onLoad = "uiNamespace setVariable ['timerDiag', _this select 0];";
		onUnLoad = "uiNamespace setVariable ['timerDiag', nil]";
		duration = 9999999;
		class controls
		{
			class SK_Frame: timer_RscFrame
			{
				idc = 1321;
				text = "Start in:"; 
				x = 0.90 * safezoneW + safezoneX;
				y = 0.17 * safezoneH + safezoneY;
				w = 0.07 * safezoneW;
				h = 0.065 * safezoneH;
			};
			
			class Objectives: timer_RscText {
				idc = 1322;
				text = "00:00"; 
				x = 0.90 * safezoneW + safezoneX;
				y = 0.183 * safezoneH + safezoneY;
				w = 0.07 * safezoneW;
				h = 0.05 * safezoneH;
			};
		};
	};
	class ramboClass
	{
		idd = 1323;
		name = "rambo";
		movingEnable = false;
		enableSimulation = true;
		onLoad = "uiNamespace setVariable ['ramboDiag', _this select 0];";
		onUnLoad = "uiNamespace setVariable ['ramboDiag', nil]";
		duration = 10;
		class controls
		{
			class SK_Frame: rambo_RscFrame
			{
				idc = 1324;
				text = "Lonewolf:"; 
				x = 0.60 * safezoneW + safezoneX;
				y = 0.57 * safezoneH + safezoneY;
				w = 0.07 * safezoneW;
				h = 0.065 * safezoneH;
			};
			
			class Objectives: rambo_RscText {
				idc = 1325;
				text = "Lost your Lads"; 
				x = 0.60 * safezoneW + safezoneX;
				y = 0.583 * safezoneH + safezoneY;
				w = 0.07 * safezoneW;
				h = 0.05 * safezoneH;
			};
		};
	};
};