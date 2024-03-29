﻿Процедура ПроверитьУстановитьВерсиюПриложения() Экспорт
	
	СписокВерсий = Новый Массив;
	СписокВерсий.Добавить("1.0.11.1");	
	СписокВерсий.Добавить("1.0.12.1");
	СписокВерсий.Добавить("1.0.12.2");
	СписокВерсий.Добавить("1.0.13.1");
	СписокВерсий.Добавить("1.0.13.2");
	СписокВерсий.Добавить("1.0.13.3");
	СписокВерсий.Добавить("1.1.0.1");
	СписокВерсий.Добавить("2.1.0.1");
	СписокВерсий.Добавить("2.1.0.2");
	СписокВерсий.Добавить("2.3.0.1");
	СписокВерсий.Добавить("2.3.0.2");	
    СписокВерсий.Добавить("2.3.1.1");
	СписокВерсий.Добавить("2.3.2.1");
    СписокВерсий.Добавить("2.3.3.1");
	СписокВерсий.Добавить("2.3.4.1");
	
	Версия = Константы.ВерсияПриложения.Получить();
	ВерсияПриложения = Метаданные.Версия;
	Если Версия <> ВерсияПриложения Тогда		 
		Если Версия = "" Тогда
			ВыполнитьПервичноеЗаполнение()
		КонецЕсли;				
		//СписокВерсий.Добавить("2.3.1.1"); 
		//СписокВерсий.Добавить("2.3.1.2");//Текущая
		//Если НЕ СписокВерсий.Найти(Версия) = Неопределено Тогда
		//	ВыполнитьОбновлениеДоВерсии_НОВАЯВЕРСИЯ();			
		//КонецЕсли;
		Константы.ВерсияПриложения.Установить(ВерсияПриложения);
	КонецЕсли;	
	
КонецПроцедуры	  

Процедура ВыполнитьПервичноеЗаполнение()
	Константы.СтильОформления.Установить(Перечисления.СтилиОформления.ПоУмолчанию);
	#Если ТонкийКлиент и ТолстыйКлиент Тогда
		Константы.ВысотаШрифтаСписка.Установить(12);	
	#Иначе	
		Константы.ВысотаШрифтаСписка.Установить(6);
	#КонецЕсли	
КонецПроцедуры