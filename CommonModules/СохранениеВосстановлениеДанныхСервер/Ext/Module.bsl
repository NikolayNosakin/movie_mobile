﻿
Функция Сохранить() Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	Жанры.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Жанры КАК Жанры
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Страны.Ссылка
	|ИЗ
	|	Справочник.Страны КАК Страны
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Кино.Ссылка
	|ИЗ
	|	Справочник.Кино КАК Кино");
	Таб = Запрос.Выполнить().Выгрузить();
	Массив = Новый Массив;
	Для каждого стр из Таб Цикл
		Массив.Добавить(стр.Ссылка.ПолучитьОбъект());
	КонецЦикла;	
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ПараметрыЗаписиJSON = Новый ПараметрыЗаписиJSON(,Символы.Таб);
	ЗаписьJSON.УстановитьСтроку(ПараметрыЗаписиJSON);
	СериализаторXDTO.ЗаписатьJSON(ЗаписьJSON, Массив, НазначениеТипаXML.Явное);
	Текст =  ЗаписьJSON.Закрыть();
	
	Возврат Текст
	
КонецФункции

Процедура Восстановить(Текст) Экспорт
	
	ЧтениеJson = Новый ЧтениеJson;
	ЧтениеJson.УстановитьСтроку(Текст);
	Массив = СериализаторXDTO.ПрочитатьJSON(ЧтениеJson);
	Для каждого стр из Массив Цикл
		стр.Записать();
	КонецЦикла;	
	ЧтениеJson.Закрыть();
	
КонецПроцедуры

