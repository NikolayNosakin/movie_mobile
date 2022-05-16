﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Адрес = "https://oauth.yandex.ru/authorize?response_type=code&client_id=" + Параметры.IDПриложения;
КонецПроцедуры

&НаКлиенте
Процедура АдресДокументСформирован(Элемент)
	ПолучитьКодАвторизации();
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	ПолучитьКодАвторизации();
КонецПроцедуры 

&НаКлиенте
Процедура ПолучитьКодАвторизации()
	Позиция = СтрНайти(Элементы.Адрес.Документ.URL, "code=");
	Если Позиция Тогда 
		Оповестить("ПолучениеКодаАвторизации", Сред(Элементы.Адрес.Документ.URL, Позиция + 5));
	КонецЕсли;
КонецПроцедуры	