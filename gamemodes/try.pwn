#include <a_samp>
#include <a_mysql>
#include <sscanf2>
#define MAILER_URL "localhost/mailer.php"
#include <mailer>
new i, car = 1;
new a[60], name [255], vehicles [20];
new	Float:x, Float:y, Float:z;


#define MYSQL_HOST "localhost"                              //имя хоста
#define MYSQL_USER "root"                                   //имя пользователя
#define MYSQL_PASSWORD ""                                   //пароль пользователя
#define MYSQL_DATABASE "sampbd"                             //имя бд

#define     Kickk(%1)   SetTimerEx("kick", 10, false, "i", %1)


enum
{
	PASSWORD_DIALOG_CREATE,
	MAIL_DIALOG_CREATE,
	SEX_DIALOG_CREATE,
	PASSWORD_DIALOG_LOGIN

}

//******************************************************Массив для записи позиции игрока (доработать)********************************************
enum pInfo
{
	pName [MAX_PLAYER_NAME],
	pPassword[31],
	pEmail[51],
	pSex[10],
	pLevel,
	pSkin,
	Float:posX,
	Float:posY,
	Float:posZ,
	Float:FaceAngle,
	AdmLevel,
	pFrac,
	pRank,
	pGang
}
//***********************************************************************************************************************************************
new playerInfo [MAX_PLAYERS][pInfo]; //переменная обращающаяся к массиву информации игрока
new MYSQL:database;
new gPlayerLogged[MAX_PLAYERS];

main()
{
	print("\n----------------------------------");
	print("Testing");
	print("----------------------------------\n");

	switch(mysql_errno())
	{
		case 0: print("Подключение к базе данных успешно");
		case 1044: print("Подключение к базе данных не удалось [Указано не правильное имя пользователя]");
		case 1045: print("Подключение к базе данных не удалось [Указан не правильный пароль]");
		case 1049: print("Подключение к базе данных не удалось [Указана не правильная база данных]");
		case 2002: print("Не удалось подключиться к БД (возможно БД лежит)");
		case 2003: print("Подключение к базе данных не удалось [База данных не доступна]");
		case 2005: print("Подключение к базе данных не удалось [Хостинг указан не верно]");
		default: printf("Подключение к базе данных не удалось. Код ошибки: [%d]. Check \\logs\\plugins", mysql_errno());
	}
	
}


public OnGameModeInit()
{
	database = mysql_connect ("127.0.0.1", "root", "", "sampbd"); //подкл к бд
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
	new status = 0;
if (!status)
	{
		ShowPlayerDialog(playerid, PASSWORD_DIALOG_CREATE, DIALOG_STYLE_INPUT, "Создание аккаунта", "Вы не зарегестрированы!\nПридумайте пароль для вашего аккаунта!", "Принять", "Выход");
		return 0;
	}
	else
	{
		ShowPlayerDialog(playerid, PASSWORD_DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Вход", "Аккаунт зарегестрирован!\nВведите пароль!", "Принять", "Выход");
	}
//SetTimerEx("CheckName", 50, false, "i", playerid);
//new string[255];
//if(mysql_errno() !=0) return SendClientMessage(playerid, -1, "Подключение к БД не удалось. Переподключение...");
// GangZoneShowForPlayer(playerid, i, 0x0000FFFF);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
//if(gPlayerLogged [playerid] == 1){
SaveAccount(playerid);
//}
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



			if(!strcmp("/cuff", cmdtext, true))
				{
				new giveplayerid, tmp[255], idx, pId;
				tmp = strtok(cmdtext, idx);
				giveplayerid = strval(tmp);
				
			//	sscanf(cmdtext, "{s}s", pId);
				TogglePlayerControllable(giveplayerid, 0);
				return 1;
				}
			if(!strcmp("/uncuff", cmdtext, true))
			    {
			    new pId;
			    sscanf(cmdtext, "{s}i", pId);
			    TogglePlayerControllable(pId, 1);
			    return 1;
				}




//	new cmd[50];
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
	// проверка уровня админка, пока без нее т.к. проще тестиравать (нет бд)
	//		if(playerInfo[playerid][AdmLevel] != 5)
	//			{
	//			SendClientMessage(playerid, 0xCDC5BF, "Вы неуполномочены использовать эту команду!");
	//			return 1;
 	//			}
 		new carid, color1, color2, string[255];
		sscanf(cmdtext, "{s}iii", carid, color1, color2);
		
	 		if(!carid)
				{
				SendClientMessage(playerid, -1, "/veh [carid][color1][color2]");
				return 1;
				}
 			if(carid < 399 || carid > 612)
 				{
 				SendClientMessage(playerid, -1, "id машины должен быть от 400 до 611");
 				return 1;
 				}

 			if(color1 <= -1 || color1 >= 255)
 				{
 				SendClientMessage(playerid, -1, "Цвет машины должен быть от -1 до 255");
 				return 1;
 				}

			if(color2 <= -1 || color2 >= 255)
 				{
 				SendClientMessage(playerid, -1, "Цвет машины должен быть от -1 до 255");
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
		if (!strcmp(cmdtext, "/dsveh", true, 6))
			{
			new count;
			sscanf(cmdtext, "{s}i", count);
			if(!count){
			    if (car>1)
    			{
				DestroyVehicle(vehicles[car-1]);
				new string [255];
				format(string, sizeof(string), "Destroy vehicle id %i", car);
				SendClientMessage(playerid, -1, string);
				car--;
				return 1;
				} else
			SendClientMessage(playerid, -1, "Cars not spayned");
   			}
			if (count <= car)
			{
			new temp;
			DestroyVehicle(vehicles[count]);
			for (new i = 1; i <= sizeof(vehicles); i++)
			    {
			    	if (!vehicles[i])
			    	{
						if(vehicles[i+1] < sizeof(vehicles))
						{
						temp = vehicles[i+1];
						vehicles[i+1] = vehicles[i];
						vehicles[i] = temp;
						}
					}
					return 1;
				}
			}
   			return 1;
			}
			
//  		if (!strcmp(cmdtext, "/banex", true, 6))
//  			{
//			new pId, reason, string [255];
//			sscanf(cmdtext, "{s}is", pId, reason);
//			format(string, sizeof(string), "Причина бана: %s", reason);
//			if (!pId || !reason)
//				{
//				SendClientMessage(playerid, -1, "Введите команду в формате /banex [playerid] [reason]");
//				return 1;
//				}
//
//			BanEx(pId, string);
//			return 1;
//		  	}

			if (!strcmp(cmdtext, "/giverank", true, 9))
				{
				new id, newRank, string [255];
				if (playerInfo[playerid][pFrac] >= 0 || playerInfo[playerid][pRank] < 9)
			    {
			    SendClientMessage (playerid, -1, "Вы неуполномочены использовать эту команду!");
			    return 1;
				}
				sscanf(cmdtext, "{i}is", id, newRank);
				if (newRank < 0 || newRank > 12)
				{
				SendClientMessage(playerid, -1, "Новый ранг должен быть от 0 до 12!");
				return 1;
				}
				format(string, sizeof(string), "Вам присвоен ранг %i", newRank);
				playerInfo[playerid][pRank] = newRank;
				return 1;
				}
			if (!strcmp(cmdtext, "/asetrank", true, 8))
				{
				new newRank, string [255];
				sscanf (cmdtext, "{s}i", newRank);
				format(string, sizeof(string), "Присвоен ранг %i", newRank);
				SendClientMessage(playerid, -1, string);
				playerInfo[playerid][pRank] = newRank;
				return 1;
				}
			if(!strcmp(cmdtext, "/asetfrac", true, 9))
				{
				new newFrac, string[255];
				sscanf(cmdtext, "{s}i", newFrac);
				format(string, sizeof(string), "Присвоена фракция %i", newFrac);
				SendClientMessage(playerid, -1, string);
				playerInfo[playerid][pFrac] = newFrac;
				frac (playerid, newFrac);
				return 1;
				}
			if(!strcmp("/check", cmdtext, true))
			{
			GameModeExit();
			return 1;
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
	        case PASSWORD_DIALOG_CREATE:
	        {
	            if (!response) //Если нажал выход
	            {
					SendClientMessage(playerid, 0x008000, "Вы были отключены. Для выхода введите /(q)uit");
					kick(playerid);
					return 0;
				}
				if (!strlen(inputtext)) //Если пустое поле ввода
				{
					ShowPlayerDialog(playerid, PASSWORD_DIALOG_CREATE, DIALOG_STYLE_INPUT, "Создание аккаунта", "Вы не зарегестрированы!\nПридумайте пароль для вашего аккаунта!", "Принять", "Выход");
					return 1;
				}
				else
				{
				    strmid(playerInfo[playerid][pPassword], inputtext, 0, strlen(inputtext));
					ShowPlayerDialog(playerid, MAIL_DIALOG_CREATE, DIALOG_STYLE_INPUT, "Создание аккаунта", "Введите ваш E-mail.\nОн необходим для восстановления доступа к аккаунту.", "Принять", "Назад");
					return 1;
				}
			}
			case MAIL_DIALOG_CREATE:
			{
				if(!response)
				{
					ShowPlayerDialog(playerid, PASSWORD_DIALOG_CREATE, DIALOG_STYLE_INPUT, "Создание аккаунта", "Вы не зарегестрированы!\nПридумайте пароль для вашего аккаунта!", "Принять", "Выход");
					return 1;
				}
				else
				{
					strmid(playerInfo[playerid][pEmail], inputtext, 0, strlen(inputtext));
					ShowPlayerDialog(playerid, SEX_DIALOG_CREATE, DIALOG_STYLE_MSGBOX, "Создание аккаунта", "Вы мужчина или женщина?", "Мужчина", "Женщина");
					return 1;
				}
			}
			case SEX_DIALOG_CREATE:
			{
				if(!response)
				{
					SendClientMessage(playerid, 0x008000, "Ок - вы женщина");
					strmid(playerInfo[playerid][pSex], "Female", 0, 5);
					playerInfo[playerid][pSkin] = 77;
				}
				else
				{
					SendClientMessage(playerid, 0x008000, "Ок - вы мужчина");
					strmid(playerInfo[playerid][pSex], "Male", 0, 3);
					playerInfo[playerid][pSkin] = 137;
				}
				playerInfo[playerid][pLevel] = 1;
 				playerInfo[playerid][posX] = 2229;
 				playerInfo[playerid][posY] = -1159;
				playerInfo[playerid][posZ] = 25;
 				playerInfo[playerid][FaceAngle] = 10;
				CreateNewAccount(playerid);
			}
		}
return 0;
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
ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, "Регистрация",
		"Этот аккаунт не зарегистрирован\nЗарегистрируйтесь, чтобы зайти.\n\tВведите пароль.", "Далее", "Выход");
return 1;
}
else
{
ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, "Вход",
		"Этот аккаунт зарегистрирован\nАвторизуйтесь, чтобы зайти.", "Далее", "Выход");

}
}





stock CreateNewAccount(playerid)
{
  	      new string[512], str[MAX_PLAYER_NAME+144], textMail[512];
	      mysql_format(database, string, sizeof(string),
		  "INSERT INTO `users` (`Name`, `Password`, `Email`, `Level`, `Sex`, `Skin`) VALUES \
		  ('%s', '%s', '%s', '%d', '%s', '%d')",
		  playerInfo[playerid][pName],
		  playerInfo[playerid][pPassword],
		  playerInfo[playerid][pEmail],
		  playerInfo[playerid][pLevel],
		  playerInfo[playerid][pSex],
		  playerInfo[playerid][pSkin]);
		  mysql_tquery(database, string);
		  gPlayerLogged[playerid] = 1;
		  //format(textMail, sizeof(textMail), "Поздравляем, ваш %s аккаунт успешно зарегистрирован!", playerInfo[playerid][pName]);
		  //SendMail(playerInfo[playerid][pEmail], "Alice@example.com", "Регистрация", "Аккаунт зарегистрирован!", textMail);
		  format(string, sizeof(str), "Аккаунт %s успешно зарегистрирован. Приятной игры!", playerInfo[playerid][pName]);
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
SendClientMessage(playerid, -1, "Некорректное имя (Прим. Vlad_Capone)");
Kickk(playerid);
}
else
{
new string[255];
format(string, sizeof(string), "SELECT * FROM `users` WHERE `Name` = '%s'", playerInfo[playerid][pName]);
mysql_tquery(database, string, "FindPlayer", "i", playerid);
//ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Добро пожаловать", "Приветствуем вас на нашем сервере", "Далее", "Выход"); //диалог при входе, будет переделан
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
		if(g == 3) ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Оповещение", "Превышен лимит на ввод пароля.\n Для выхода введите /q", "OK", "");
		format(string, sizeof(string), "{FFFFFF}Вы ввели не правильный пароль: {FF0000}%s\n{FFFFFF}Осталось попыток: {FF0000}%d\n\n{FFFFFF}Повторите попытку", inputtext, 3-g);
		ShowPlayerDialog(playerid, 4, DIALOG_STYLE_INPUT, "Авторизация", string, "Войти", "Выйти");
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
		SendClientMessage(playerid, -1, "Вы авторизовались");
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


public frac (playerid, newFrac)
{

	switch (newFrac)
	{
		case 1:
		{
		SetPlayerSkin(playerid, 155);
		}
		case 2:
		{
        SetPlayerSkin(playerid, 155);
		}
		case 3:
		{
		SetPlayerSkin(playerid, 155);
		}
		case 4:
		{
		SetPlayerSkin(playerid, 155);
		}
		case 5:
		{
		SetPlayerSkin(playerid, 155);
		}
		case 6:
		{
		SetPlayerSkin(playerid, 155);
		}
		case 7:
		{
		SetPlayerSkin(playerid, 155);
		}
		case 8:
		{
		SetPlayerSkin(playerid, 155);
		}
		case 9:
		{
		SetPlayerSkin(playerid, 155);
		}
		case 10:
		{
		SetPlayerSkin(playerid, 155);
		}
		case 11:
		{
		SetPlayerSkin(playerid, 155);
		}
		case 12:
		{
		SetPlayerSkin(playerid, 155);
		}
		default:
		{
		}
	}
}


stock strtok(const string[], &index)
{
        new length = strlen(string);
        while ((index < length) && (string[index] <= ' '))
        {
                index++;
        }

        new offset = index;
        new result[20];
        while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
        {
                result[index - offset] = string[index];
                index++;
        }
        result[index - offset] = EOS;
        return result;
}








