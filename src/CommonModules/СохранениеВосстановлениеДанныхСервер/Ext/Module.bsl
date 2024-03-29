﻿
Функция Сохранить() Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	ПРЕДСТАВЛЕНИЕ(УНИКАЛЬНЫЙИДЕНТИФИКАТОР(Жанры.Ссылка)) КАК Ссылка,
	|	Жанры.Наименование КАК Наименование
	|ИЗ
	|	Справочник.Жанры КАК Жанры
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПРЕДСТАВЛЕНИЕ(УНИКАЛЬНЫЙИДЕНТИФИКАТОР(Страны.Ссылка)) КАК Ссылка,
	|	Страны.Наименование КАК Наименование
	|ИЗ
	|	Справочник.Страны КАК Страны
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПРЕДСТАВЛЕНИЕ(УНИКАЛЬНЫЙИДЕНТИФИКАТОР(Кино.Ссылка)) КАК Ссылка,
	|	Кино.Код КАК Код,
	|	Кино.Наименование КАК Наименование,
	|	Кино.ГодВыпуска КАК ГодВыпуска,
	|	Кино.ГодОкончания КАК ГодОкончания,
	|	Кино.КодIMDB КАК КодIMDB,
	|	Кино.КодКинопоиск КАК КодКинопоиск,
	|	Кино.КоличествоСезонов КАК КоличествоСезонов,
	|	Кино.Описание КАК Описание,
	|	Кино.ОригинальноеНазвание КАК ОригинальноеНазвание,
	|	ПРЕДСТАВЛЕНИЕ(Кино.Тип.Ссылка) КАК Тип,
	|	Кино.Просмотрен КАК Просмотрен
	|ИЗ
	|	Справочник.Кино КАК Кино
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПРЕДСТАВЛЕНИЕ(УНИКАЛЬНЫЙИДЕНТИФИКАТОР(КиноЖанры.Ссылка)) КАК Ссылка,
	|	ПРЕДСТАВЛЕНИЕ(УНИКАЛЬНЫЙИДЕНТИФИКАТОР(КиноЖанры.Жанр)) КАК Жанр
	|ИЗ
	|	Справочник.Кино.Жанры КАК КиноЖанры
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПРЕДСТАВЛЕНИЕ(УНИКАЛЬНЫЙИДЕНТИФИКАТОР(КиноСерии.Ссылка)) КАК Ссылка,
	|	КиноСерии.Сезон КАК Сезон,
	|	КиноСерии.Серия КАК Серия,
	|	КиноСерии.Описание КАК Описание,
	|	КиноСерии.ДатаВыходаСерии КАК ДатаВыходаСерии,
	|	КиноСерии.НазваниеСерии КАК НазваниеСерии,
	|	КиноСерии.Просмотрена КАК Просмотрена
	|ИЗ
	|	Справочник.Кино.Серии КАК КиноСерии
	|
	|УПОРЯДОЧИТЬ ПО
	|	КиноСерии.НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПРЕДСТАВЛЕНИЕ(УНИКАЛЬНЫЙИДЕНТИФИКАТОР(КиноСтраны.Ссылка)) КАК Ссылка,
	|	ПРЕДСТАВЛЕНИЕ(УНИКАЛЬНЫЙИДЕНТИФИКАТОР(КиноСтраны.Страна)) КАК Страна
	|ИЗ
	|	Справочник.Кино.Страны КАК КиноСтраны");
	МассивРезультатов = Запрос.ВыполнитьПакет();
	ТабЖанры = МассивРезультатов[0].Выгрузить();
	ТабСтраны = МассивРезультатов[1].Выгрузить();
	ТабКино = МассивРезультатов[2].Выгрузить();
	ТабКиноЖанры = МассивРезультатов[3].Выгрузить();
	ТабКиноСерии = МассивРезультатов[4].Выгрузить();
	ТабКиноСтраны = МассивРезультатов[5].Выгрузить();
	
	СтруктураСправочниов = Новый Структура;
	СтруктураСправочниов.Вставить("Жанры",ОбщегоНазначения.ТаблицаЗначенийВМассивСтруктур(ТабЖанры));
	СтруктураСправочниов.Вставить("Страны",ОбщегоНазначения.ТаблицаЗначенийВМассивСтруктур(ТабСтраны));
	СтруктураСправочниов.Вставить("Кино",ОбщегоНазначения.ТаблицаЗначенийВМассивСтруктур(ТабКино));
	СтруктураСправочниов.Вставить("КиноЖанры",ОбщегоНазначения.ТаблицаЗначенийВМассивСтруктур(ТабКиноЖанры));
	СтруктураСправочниов.Вставить("КиноСерии",ОбщегоНазначения.ТаблицаЗначенийВМассивСтруктур(ТабКиноСерии));
	СтруктураСправочниов.Вставить("КиноСтраны",ОбщегоНазначения.ТаблицаЗначенийВМассивСтруктур(ТабКиноСтраны));
	
	Данные = Новый структура();
	Данные.Вставить("kinopoisk_unofficial_api_token",Константы.kinopoisk_unofficial_api_token.Получить());
	Данные.Вставить("ИспользуетсяЗаполнениеИзКинопоискаПоАПИ",Константы.ИспользуетсяЗаполнениеИзКинопоискаПоАПИ.Получить());
	Данные.Вставить("СтильОформления",XMLСтрока(Константы.СтильОформления.Получить()));	
	Данные.Вставить("Справочники",СтруктураСправочниов);	
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ПараметрыЗаписиJSON = Новый ПараметрыЗаписиJSON(,Символы.Таб);
	ЗаписьJSON.УстановитьСтроку(ПараметрыЗаписиJSON);
	ЗаписатьJSON(ЗаписьJSON, Данные, Новый НастройкиСериализацииJSON);
	Текст = ЗаписьJSON.Закрыть();
	
	Возврат Текст
	
КонецФункции

Процедура Восстановить(Текст, Лог = "") Экспорт
	
	УдалитьДанныеСправочников();
	
	ЧтениеJson = Новый ЧтениеJson;
	ЧтениеJson.УстановитьСтроку(Текст);
	Попытка
		Данные = ПрочитатьJSON(ЧтениеJson);	
		Константы.kinopoisk_unofficial_api_token.Установить(Данные.kinopoisk_unofficial_api_token);
		Константы.ИспользуетсяЗаполнениеИзКинопоискаПоАПИ.Установить(Данные.ИспользуетсяЗаполнениеИзКинопоискаПоАПИ);
		Константы.СтильОформления.Установить(Перечисления.СтилиОформления[Данные.СтильОформления]);
		КиноСтраны = ОбщегоНазначения.МассивВТаблицуЗначений(Данные.Справочники.КиноСтраны);
		КиноЖанры = ОбщегоНазначения.МассивВТаблицуЗначений(Данные.Справочники.КиноЖанры); 
		КиноСерии = ОбщегоНазначения.МассивВТаблицуЗначений(Данные.Справочники.КиноСерии); 
		Для каждого стр из Данные.Справочники.Жанры Цикл
			РезСсылка = Справочники.Жанры.ПолучитьСсылку(Новый УникальныйИдентификатор(стр.Ссылка));
			ОбЖанр = Справочники.Жанры.СоздатьЭлемент();	
			ОбЖанр.УстановитьСсылкуНового(РезСсылка);
			ОбЖанр.Наименование = стр.Наименование;
			Попытка
				ОбЖанр.Записать();
			Исключение
				//
			КонецПопытки; 	
		КонецЦикла;
		
		Для каждого стр из Данные.Справочники.Страны Цикл
			РезСсылка = Справочники.Страны.ПолучитьСсылку(Новый УникальныйИдентификатор(стр.Ссылка));
			ОбСтраны = Справочники.Страны.СоздатьЭлемент();	
			ОбСтраны.УстановитьСсылкуНового(РезСсылка);
			ОбСтраны.Наименование = стр.Наименование;
			Попытка
				ОбСтраны.Записать();
			Исключение
				//
			КонецПопытки; 	
		КонецЦикла;
		
		Для каждого стр из Данные.Справочники.Кино Цикл
			РезСсылка = Справочники.Кино.ПолучитьСсылку(Новый УникальныйИдентификатор(стр.Ссылка));
			ОбКино = Справочники.Кино.СоздатьЭлемент();	
			ОбКино.УстановитьСсылкуНового(РезСсылка);
			ЗаполнитьЗначенияСвойств(ОбКино,стр,,"Ссылка");
			ОбКино.Тип = Перечисления.ТипыКино[стр.Тип];
			СтрокиЖанр = КиноЖанры.НайтиСтроки(Новый структура("Ссылка",стр.Ссылка)); 
			Для каждого стрЖанр Из СтрокиЖанр Цикл
				СтрЖанры = ОбКино.Жанры.Добавить();
				СтрЖанры.Жанр = Справочники.Жанры.ПолучитьСсылку(Новый УникальныйИдентификатор(стрЖанр.Жанр));
			КонецЦикла;
			СтрокиСтраны = КиноСтраны.НайтиСтроки(Новый структура("Ссылка",стр.Ссылка)); 
			Для каждого стрСтрана Из СтрокиСтраны Цикл
				СтрЖанры = ОбКино.Страны.Добавить();
				СтрЖанры.Страна = Справочники.Страны.ПолучитьСсылку(Новый УникальныйИдентификатор(стрСтрана.Страна));
			КонецЦикла;
			СтрокиСерии = КиноСерии.НайтиСтроки(Новый структура("Ссылка",стр.Ссылка)); 
			Для каждого стрСерия Из СтрокиСерии Цикл
				СтрСерии = ОбКино.Серии.Добавить();
				ЗаполнитьЗначенияСвойств(СтрСерии,СтрСерия);
			КонецЦикла;			
			Попытка
				ОбКино.Записать();
			Исключение
				//
			КонецПопытки; 	
		КонецЦикла;
		
	Исключение
		Сообщить("Ошибка: " + ОписаниеОшибки());
	КонецПопытки;
	ЧтениеJson.Закрыть();
	
КонецПроцедуры

Процедура УдалитьДанныеСправочников()
	
	Выборка = Справочники.Жанры.Выбрать(); 
	Пока Выборка.Следующий() Цикл 
		СпрОбъект = Выборка.Ссылка.ПолучитьОбъект();	
		СпрОбъект.Удалить(); 
	КонецЦикла; 
	
	Выборка = Справочники.Кино.Выбрать(); 
	Пока Выборка.Следующий() Цикл 
		СпрОбъект = Выборка.Ссылка.ПолучитьОбъект();	
		СпрОбъект.Удалить(); 
	КонецЦикла; 
	
	Выборка = Справочники.Страны.Выбрать(); 
	Пока Выборка.Следующий() Цикл 
		СпрОбъект = Выборка.Ссылка.ПолучитьОбъект();	
		СпрОбъект.Удалить(); 
	КонецЦикла;
	
КонецПроцедуры