#include <a_samp>
#include <a_mysql>
#include <sscanf2>
#define MAILER_URL "localhost/mailer.php"
#include <mailer>
new i, car = 1;
new a[60], name [255], vehicles [20];
new	Float:x, Float:y, Float:z;


#define MYSQL_HOST "185.139.68.64"                              //��� �����
#define MYSQL_USER "gs127001"                                   //��� ������������
#define MYSQL_PASSWORD "BeiENHAsogte"                                   //������ ������������
#define MYSQL_DATABASE "gs127001"                             //��� ��


#define     Kickk(%1)   SetTimerEx("kick", 10, false, "i", %1)

//******************************************************������ ��� ������ ������� ������ (����������)********************************************
enum pInfo
{
	pName [MAX_PLAYER_NAME],
	pPassword[31],
	pEmail[51],
	pSex,
	pLevel,
	pSkin,
	Float:posX,
	Float:posY,
	Float:posZ,
	Float:FaceAngle,
	AdmLevel,
	pHealth,
	pArmor
}
//***********************************************************************************************************************************************
new playerInfo [MAX_PLAYERS][pInfo]; //���������� ������������ � ������� ���������� ������
new MYSQL:database;
new gPlayerLogged[MAX_PLAYERS];

main()
{
	print("\n----------------------------------");
	print("Testing");
	print("----------------------------------\n");

	switch(mysql_errno())
	{
		case 0: print("����������� � ���� ������ �������");
		case 1044: print("����������� � ���� ������ �� ������� [������� �� ���������� ��� ������������]");
		case 1045: print("����������� � ���� ������ �� ������� [������ �� ���������� ������]");
		case 1049: print("����������� � ���� ������ �� ������� [������� �� ���������� ���� ������]");
		case 2003: print("����������� � ���� ������ �� ������� [���� ������ �� ��������]");
		case 2005: print("����������� � ���� ������ �� ������� [������� ������ �� �����]");
		default: printf("����������� � ���� ������ �� �������. ��� ������: [%d]", mysql_errno());
	}
	
}


public OnGameModeInit()
{
	database = mysql_connect (MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE); //����� � ��
	SetGameModeText("newAlpha");
	DisableInteriorEnterExits();
//	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
 //i = GangZoneCreate(1958.3783, 1343.1572, 15.3746, 269.1425);
	
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

//public OnPlayerRequestClass(playerid, classid)
//{
//		if(gPlayerLogged [playerid] == 1)
//		{
//	spawnPlayer(playerid);
//		}
			
//}

public OnPlayerConnect(playerid)
{
SetTimerEx("CheckName", 50, false, "i", playerid);
//ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "����� ����������!", "����� ���������� �� ��� ������!", "�����", "�����");
//new string[255];
//if(mysql_errno() !=0) return SendClientMessage(playerid, -1, "����������� � �� �� �������. ���������������...");
// GangZoneShowForPlayer(playerid, i, 0x0000FFFF);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
if(gPlayerLogged [playerid] == 1){
SaveAccount(playerid);
}
	return 1;
}

public OnPlayerSpawn(playerid)
{
			SetPlayerSkin(playerid, playerInfo[playerid][pSkin]);
			SetPlayerPos(playerid, playerInfo[playerid][posX], playerInfo[playerid][posY], playerInfo[playerid][posZ]);
			SetPlayerFacingAngle(playerid, playerInfo[playerid][FaceAngle]);
			SetPlayerScore(playerid, playerInfo[playerid][pLevel]);
			
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (!strcmp("/pos", cmdtext, true))
	{
	GetPlayerPos(playerid, x, y, z);
	new position[255];
	format(position, sizeof(position), "%f, %f, %f", x, y, z);
	SendClientMessage(playerid, -1, position);

  	return 1;
	}

	if (!strcmp(cmdtext, "/veh", true, 4))
	{
			if(playerInfo[playerid][AdmLevel] < 5)
				{
				SendClientMessage(playerid, 0xFF0000, "�� �������������� ������������ ��� �������!");
				return 1;
 				}
 		new carid, color1, color2, string[255];
		sscanf(cmdtext, "{s}iii", carid, color1, color2);

	 		if(!carid)
				{
				SendClientMessage(playerid, -1, "/veh [carid][color1][color2]");
				return 1;
				}
 			if(carid < 399 || carid > 612)
 				{
 				SendClientMessage(playerid, -1, "id ������ ������ ���� �� 400 �� 611");
 				return 1;
 				}

 			if(color1 <= -1 || color1 >= 255)
 				{
 				SendClientMessage(playerid, -1, "���� ������ ������ ���� �� -1 �� 255");
 				return 1;
 				}

			if(color2 <= -1 || color2 >= 255)
 				{
 				SendClientMessage(playerid, -1, "���� ������ ������ ���� �� -1 �� 255");
 				return 1;
 				}
			if (car <=20)
			{
			GetPlayerPos(playerid, x, y, z);
			vehicles [car] = CreateVehicle(carid, x+5, y+5, z, 0, color1, color2, -1);
			new string[255];
			format(string, sizeof(string), "Create vehicle id %i", car);
   			SendClientMessage(playerid, -1, string);
   			car++;
			return 1;
			}
			return 1;
	}
	//�������� �� ������� ����������� �����
		if (!strcmp(cmdtext, "/dsveh", true, 6))
			{
			    if (car>1)
    			{
				DestroyVehicle(vehicles[car-1]);
    			car--;
				new string [255];
				format(string, sizeof(string), "Destroy vehicle id %i", car);
				SendClientMessage(playerid, -1, string);
				return 1;
				} else
			SendClientMessage(playerid, -1, "Cars not spayned");
   			return 1;
			}
  		if (!strcmp(cmdtext, "/recon", true, 6)) //������� ��� ���� ��������
  		    {
  		    	if(playerInfo[playerid][AdmLevel] < 3)
  		    	{
  		    	SendClientMessage(playerid, 0xFF0000, "�� �� ������������ ������������ ��� �������!");
  		    	return 1;
		  		}
		  	}
  
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
			switch(dialogid)
	{
	    case 1:
  		{
	    if(!response){
	        SendClientMessage (playerid, 0xEE3B3B, "��� ������ ������� /(q)uit");
	        Kickk(playerid);
	        return 1;
	    } else
	    if(!strlen(inputtext)) return ShowPlayerLoginDialog(playerid, 1, 0);
	    for (new j = strlen(inputtext); j != 0; --j){
					switch(inputtext[j]){
					case ' ', '=': return ShowPlayerDialog(playerid, 1, DIALOG_STYLE_INPUT, "������",
							"{FFFF00}������: {FFFFFF}�� ����� ����������� �������.", "�����", "�����");
					}
	    }
	 if(strlen(inputtext) < 5 || strlen(inputtext) > 20) return ShowPlayerDialog(playerid, 1, DIALOG_STYLE_INPUT, "������",
			"{FFFF00}������: {FFFFFF}������ ������ ���� �� ������ 6 � �� ������ 20 ��������.", "�����", "�����"); else
//	for(new j = strlen(inputtext); j !=0; --j){
// switch(inputtext[j]){
// case 'a'..'z', 'A'..'Z': return ShowPlayerDialog(playerid, 1, DIALOG_STYLE_INPUT, "������",
//			"{FFFF00}������: {FFFFFF}�� ����� ����.", "�����", "�����");
 //}
//	}
		strmid(playerInfo[playerid][pPassword], inputtext, 0, strlen(inputtext), 21);
		ShowPlayerDialog(playerid, 2, DIALOG_STYLE_INPUT, "��� Email", "������� ��� Email", "�����", "�����");
		}
	case 2:
	{
	if(!response) return ShowPlayerLoginDialog(playerid, 1, 0); else
	if(!strlen(inputtext)) return ShowPlayerDialog(playerid, 2, DIALOG_STYLE_INPUT, "������", "���� �� ������ ���� ������!", "�����", "�����"); else
	if(!(strfind(inputtext, "@", true) != 1 && strfind(inputtext, ".", true) !=1) && strlen(inputtext) > 50 || strlen(inputtext) < 10) return ShowPlayerDialog(playerid, 2, DIALOG_STYLE_INPUT, "������", "{FFFF00}������: {FFFFFF}Email ������ ���� �� ����� 10 � �� ����� 50 �������, ��������� ����� @ � .", "�����", "�����"); else
	strmid(playerInfo[playerid][pEmail], inputtext, 0, strlen(inputtext), 51);
	ShowPlayerDialog (playerid, 3, DIALOG_STYLE_MSGBOX, "����� ����", "�� ������� ��� �������?", "�������", "�������");
	}
	case 3:
	{
	
 if(response){
    playerInfo[playerid][pSex] = 1;
    playerInfo[playerid][pSkin] = 137;
    SendClientMessage(playerid, -1, "��, �� - �������");
 }
 else
 {
    playerInfo[playerid][pSex] = 2;
    playerInfo[playerid][pSkin] = 77;
    SendClientMessage(playerid, -1, "��, �� - �������");
 }
 playerInfo[playerid][pLevel] = 1;
 playerInfo[playerid][posX] = 2229;
 playerInfo[playerid][posY] = -1159;
 playerInfo[playerid][posZ] = 25;
 playerInfo[playerid][FaceAngle] = 10;
 CreateNewAccount(playerid);
 
	}
	case 4:
	{
		if(!response)
			{
		SendClientMessage(playerid, 0xEE3B3B, "��� ������ ������� (/q)uit");
		Kickk(playerid);
		return 1;
				}
		if(!strlen(inputtext)) return ShowPlayerLoginDialog(playerid, 4, 1);
		new string[128];
		mysql_format(database, string, sizeof(string), "SELECT * FROM `users` WHERE `Name` = '%e' AND `Password` = '%e'", playerInfo[playerid][pName], inputtext);
		mysql_tquery(database, string, "UploadPlayerAccount", "ds", playerid, inputtext);
	}
 		}
 }




public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

public kick(playerid)
{
Kick(playerid);
return 1;
}






stock SaveAccount(playerid)
{
GetPlayerPos(playerid, x, y, z);
GetPlayerFacingAngle(playerid, playerInfo[playerid][FaceAngle]);
playerInfo[playerid][posX] = x;
playerInfo[playerid][posY] = y;
playerInfo[playerid][posZ] = z;
new query_string[512] = "UPDATE `users` SET";
		format(query_string, sizeof(query_string), "%s `Level` = '%d',", query_string, playerInfo[playerid][pLevel]);
		format(query_string, sizeof(query_string), "%s `Skin` = '%d',", query_string, playerInfo[playerid][pSkin]);
  		format(query_string, sizeof(query_string), "%s `x` = '%f',", query_string, playerInfo[playerid][posX]);
  		format(query_string, sizeof(query_string), "%s `y` = '%f',", query_string, playerInfo[playerid][posY]);
  		format(query_string, sizeof(query_string), "%s `z` = '%f',", query_string, playerInfo[playerid][posZ]);
  		format(query_string, sizeof(query_string), "%s `FaceAngle` = '%f'", query_string, playerInfo[playerid][FaceAngle]);
  		format(query_string, sizeof(query_string), "%s WHERE `Name` = '%s'", query_string, playerInfo[playerid][pName]);
		mysql_tquery(database, query_string);
}






stock ShowPlayerLoginDialog (playerid, dialogid = 0, login = 0)
{
if (!login)
{
ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, "�����������",
		"���� ������� �� ���������������\n�����������������, ����� �����.\n\t������� ������.", "�����", "�����");
}
else
{
ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, "����",
		"���� ������� ���������������\n�������������, ����� �����.", "�����", "�����");
}
}





stock CreateNewAccount(playerid)
{
  	      new string[512], str[MAX_PLAYER_NAME+144], textMail[512];
	      format(string, sizeof(string),
		  "INSERT INTO `users` (`Name`, `Password`, `Email`, `Level`, `Sex`, `Skin`) VALUES \
		  ('%s', '%s', '%s', '%d', '%d', '%d')",
		  playerInfo[playerid][pName],
		  playerInfo[playerid][pPassword],
		  playerInfo[playerid][pEmail],
		  playerInfo[playerid][pLevel],
		  playerInfo[playerid][pSex],
		  playerInfo[playerid][pSkin]);
		  mysql_tquery(database, string);
		  gPlayerLogged[playerid] = 1;
		  //format(textMail, sizeof(textMail), "�����������, ��� %s ������� ������� ���������������!", playerInfo[playerid][pName]);
		  //SendMail(playerInfo[playerid][pEmail], "Alice@example.com", "�����������", "������� ���������������!", textMail);
		  format(string, sizeof(str), "������� %s ������� ���������������. �������� ����!", playerInfo[playerid][pName]);
		  SendClientMessage(playerid, -1, string);
		  return true;
}





public CheckName(playerid){
GetPlayerName(playerid, playerInfo [playerid] [pName], MAX_PLAYER_NAME);
if(strfind(playerInfo[playerid][pName], "_", true) == -1){
//for (new j = strlen(name); j !=0; --j){
//	switch(name[j]){
//	case
//	}
SendClientMessage(playerid, -1, "������������ ��� (����. Vlad_Capone)");
Kickk(playerid);
}
else
{
new string[255];
format(string, sizeof(string), "SELECT * FROM `users` WHERE `Name` = '%s'", playerInfo[playerid][pName]);
mysql_tquery(database, string, "FindPlayer", "i", playerid);
//ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "����� ����������", "������������ ��� �� ����� �������", "�����", "�����"); //������ ��� �����, ����� ���������
}
//new checkNm [522];
//cache_get_value_name(0, "Name", checkNm);

//if(checkNm == playerInfo[playerid][pName]) return ShowPlayerLoginDialog(playerid, 4, 1);

return 1;
}


public FindPlayer(playerid)
{
new rows;
cache_get_row_count(rows);
if(!rows)
{
ShowPlayerLoginDialog(playerid, 1, 0);
}
else
{
ShowPlayerLoginDialog(playerid, 4, 1);
}

}


public UploadPlayerAccount(playerid, inputtext[])
{
	new rows;
	cache_get_row_count(rows);
	if(!rows)
	{
		new string[150];
		new g = GetPVarInt(playerid, "playertryes");
		SetPVarInt(playerid, "playertryes", g+1);
		if(g == 3) ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "����������", "�������� ����� �� ���� ������.\n ��� ������ ������� /q", "OK", "");
		format(string, sizeof(string), "{FFFFFF}�� ����� �� ���������� ������: {FF0000}%s\n{FFFFFF}�������� �������: {FF0000}%d\n\n{FFFFFF}��������� �������", inputtext, 3-g);
		ShowPlayerDialog(playerid, 4, DIALOG_STYLE_INPUT, "�����������", string, "�����", "�����");
	}
	else
	{
		cache_get_value_name_int(0, "Level", playerInfo[playerid][pLevel]);
		cache_get_value_name_int(0, "Sex", playerInfo[playerid][pSex]);
		cache_get_value_name_int(0, "Skin", playerInfo[playerid][pSkin]);
		cache_get_value_name_int(0, "X", playerInfo[playerid][posX]);
		cache_get_value_name_int(0, "Y", playerInfo[playerid][posY]);
		cache_get_value_name_int(0, "Z", playerInfo[playerid][posZ]);
		cache_get_value_name_int(0, "FaceAngle", playerInfo[playerid][FaceAngle]);
		cache_get_value_name_int(0, "AdmLevel", playerInfo[playerid][AdmLevel]);
		gPlayerLogged[playerid] = 1;
		SendClientMessage(playerid, -1, "�� ��������������");
	//	SpawnPlayer(playerid);
}
}
//stock CheckRegAccount(playerid){
//new CheckName [MAX_PLAYERS];
//cache_get_value_name(0, "Name", CheckName);
//if(CheckName ==
//}


stock spawnPlayer (playerid)
{
		SetPlayerSkin(playerid, playerInfo[playerid][pSkin]);
		SetPlayerPos(playerid, playerInfo[playerid][posX], playerInfo[playerid][posY], playerInfo[playerid][posZ]);
		SetPlayerFacingAngle(playerid, playerInfo[playerid][FaceAngle]);
		SetPlayerScore(playerid, playerInfo[playerid][pLevel]);
}
