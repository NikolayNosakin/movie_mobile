﻿#Область ПрограммныйИнтерфейс

// Обменивает заранее полученный код авторизации на токен. Код авторизации нужно
// предварительно поместить в реквизит обработки КодАвторизации. Полученный токен 
// записывается в реквизит Токен. Требуется для работоспособности других методов.
//
Процедура Токен(СтруктураПараметров) Экспорт
	
	ИмяСервера = "oauth.yandex.ru";
	ОтносительныйURL = "/token";
	
	СтрокаЗапроса = "grant_type=authorization_code" +
		"&code=" 			+ СтруктураПараметров.КодАвторизации + 
		"&client_id=" 		+ ПолучитьIDПриложения() + 
		"&client_secret=" 	+ ПолучитьПарольПриложения();
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/x-www-form-urlencoded");
	Заголовки.Вставить("Content-Length", XMLСтрока(СтрДлина(СтрокаЗапроса)));
	
	HttpЗапрос = Новый HTTPЗапрос(ОтносительныйURL, Заголовки);
	HttpЗапрос.УстановитьТелоИзСтроки(СтрокаЗапроса);
	
	HttpСоединение = Новый HTTPСоединение(ИмяСервера, 443,,,, 60, Новый ЗащищенноеСоединениеOpenSSL);
	HttpОтвет = HttpСоединение.ОтправитьДляОбработки(HttpЗапрос);

	ТелоОтвета = HttpОтвет.ПолучитьТелоКакСтроку(КодировкаТекста.UTF8);
	ОбработатьКодСостояния(HttpОтвет, ОтносительныйURL, ТелоОтвета);
	
	Чтение = Новый ЧтениеJSON;
	Чтение.УстановитьСтроку(ТелоОтвета);
	Ответ = ФабрикаXDTO.ПрочитатьJSON(Чтение);
	
	СтруктураПараметров.Токен = Ответ.access_token;
	СтруктураПараметров.СрокДействияТокена = ТекущаяДата() + Ответ.expires_in;
	
КонецПроцедуры

// Получает список файлов по переданному пути на Яндекс.Диске. Полученный 
// список загружается в табличную часть СписокФайлов.
// 
// Параметры:
//  Путь     - Строка, например "app:/" - файлы из папки приложения. Если передать "disk:/", то будет получен 
//			   список файлов из общей папки
//  Смещение - Число - смещение относительно начала списка. Используется для рекурсивного 
//		использования метода в постраничном чтении списка
// 
Процедура СписокФайлов(Знач Путь = "app:/", Знач Смещение = 0, СтруктураПараметров, СписокФайлов) Экспорт
	
	Если Смещение = 0 Тогда
		СписокФайлов.Очистить();
	КонецЕсли;
	
	ИмяСервера = "cloud-api.yandex.net";
	ОтносительныйURL = 
		"/v1/disk/resources?path=" + Путь +
		"&offset=" + XMLСтрока(Смещение);
	
	Заголовки = СформироватьЗаголовки(СтруктураПараметров);
	
	HttpЗапрос = Новый HTTPЗапрос(ОтносительныйURL, Заголовки);
	
	HttpСоединение = Новый HTTPСоединение(ИмяСервера, 443,,,, 60, Новый ЗащищенноеСоединениеOpenSSL);
	HttpОтвет = HttpСоединение.Получить(HttpЗапрос);

	ТелоОтвета = HttpОтвет.ПолучитьТелоКакСтроку(КодировкаТекста.UTF8);
	ОбработатьКодСостояния(HttpОтвет, ОтносительныйURL, ТелоОтвета);
	
	Чтение = Новый ЧтениеJSON;
	Чтение.УстановитьСтроку(ТелоОтвета);
	Ответ = ФабрикаXDTO.ПрочитатьJSON(Чтение);
	
	Если Ответ._embedded.total - Ответ._embedded.offset > 1 Тогда
		Для Каждого Item Из Ответ._Embedded.Items.Items Цикл
			Стр = СписокФайлов.Добавить();
			Стр.Имя = Item.Name;
			Стр.Тип = Item.Type;
			Стр.Путь = Item.Path;
		КонецЦикла;
	ИначеЕсли Ответ._embedded.total - Ответ._embedded.offset = 1 Тогда
		Стр = СписокФайлов.Добавить();
		Стр.Имя = Ответ._Embedded.Items.Items.Name;
		Стр.Тип = Ответ._Embedded.Items.Items.Type;
		Стр.Путь = Ответ._Embedded.Items.Items.Path;
	КонецЕсли;
	
	Если Ответ._embedded.total > Ответ._embedded.limit + Ответ._embedded.offset Тогда
		СписокФайлов(Путь, Мин(Смещение + Ответ._embedded.limit, Ответ._embedded.total), СтруктураПараметров, СписокФайлов); 
	КонецЕсли;
	
КонецПроцедуры

// Создает папку на Яндекс.Диске по переданному пути.
//
// Параметры:
//  Путь - Строка - полный путь к создаваемой папке, например "disk:/фото/новая папка"
//
Процедура СоздатьПапку(Знач Путь,СтруктураПараметров) Экспорт
	
	ИмяСервера = "cloud-api.yandex.net";
	ОтносительныйURL = "/v1/disk/resources?path=" + Путь;
	
	Заголовки = СформироватьЗаголовки(СтруктураПараметров);
	
	HttpЗапрос = Новый HTTPЗапрос(ОтносительныйURL, Заголовки);
	HttpЗапрос.УстановитьТелоИзСтроки("");
	
	HttpСоединение = Новый HTTPСоединение(ИмяСервера, 443,,,, 60, Новый ЗащищенноеСоединениеOpenSSL);
	HttpОтвет = HttpСоединение.Записать(HTTPЗапрос);

	ТелоОтвета = HttpОтвет.ПолучитьТелоКакСтроку(КодировкаТекста.UTF8);
	ОбработатьКодСостояния(HttpОтвет, ОтносительныйURL, ТелоОтвета);
	
КонецПроцедуры

// Удаляет папку или файл на Яндекс.Диске  по переданному пути.
//
// Параметры:
//  Путь - Строка - полный путь к удаляемой папке или файлу, например "disk:/фото/1.jpg"
//
Процедура УдалитьПапкуИлиФайл(Знач Путь,СтруктураПараметров) Экспорт
	
	СтруктураПараметров.СписокФайлов.Очистить();
	
	ИмяСервера = "cloud-api.yandex.net";
	ОтносительныйURL = "/v1/disk/resources?path=" + Путь;
	
	Заголовки = СформироватьЗаголовки(СтруктураПараметров);
	
	HttpЗапрос = Новый HTTPЗапрос(ОтносительныйURL, Заголовки);
	
	HttpСоединение = Новый HTTPСоединение(ИмяСервера, 443,,,, 60, Новый ЗащищенноеСоединениеOpenSSL);
	HttpОтвет = HttpСоединение.Удалить(HttpЗапрос);

	ТелоОтвета = HttpОтвет.ПолучитьТелоКакСтроку(КодировкаТекста.UTF8);
	ОбработатьКодСостояния(HttpОтвет, ОтносительныйURL, ТелоОтвета);
	
КонецПроцедуры

// Загружает файл на Яндекс.Диск.
//
// Параметры:
//  Путь 		   - Строка - полный путь к загружаемому файлу, например "disk:/фото/1.jpg" / "app:/фото/1.jpg"
//  АдресХранилища - Строка - адрес файла во временном хранилище
//  Перезаписывать - Булево - признак перезаписи файла, учитывается при наличии файла с таким же именем
//
Процедура ЗагрузитьФайл(Знач Путь, Знач АдресХранилища, Знач Перезаписывать = Ложь, СтруктураПараметров) Экспорт
	
	ИмяСервера = "cloud-api.yandex.net";
	ОтносительныйURL = 
		"/v1/disk/resources/upload?path=" + Путь + 
		"&overwrite=" + XMLСтрока(Перезаписывать);
	
	Заголовки = СформироватьЗаголовки(СтруктураПараметров);
	
	HttpЗапрос = Новый HTTPЗапрос(ОтносительныйURL, Заголовки);
	
	HttpСоединение = Новый HTTPСоединение(ИмяСервера, 443,,,,, Новый ЗащищенноеСоединениеOpenSSL);
	HttpОтвет = HttpСоединение.Получить(HTTPЗапрос);

	ТелоОтвета = HttpОтвет.ПолучитьТелоКакСтроку(КодировкаТекста.UTF8);
	ОбработатьКодСостояния(HttpОтвет, ОтносительныйURL, ТелоОтвета);
	
	Чтение = Новый ЧтениеJSON;
	Чтение.УстановитьСтроку(ТелоОтвета);
	Ответ = ФабрикаXDTO.ПрочитатьJSON(Чтение);
	
	СтруктураURL = РазделитьURL(Ответ.href);
	HttpСоединение = Новый HTTPСоединение(СтруктураURL.ИмяСервера, СтруктураURL.Порт,,,,, Новый ЗащищенноеСоединениеOpenSSL);
	HttpЗапрос = Новый HTTPЗапрос(СтруктураURL.Путь, Заголовки);
	HttpЗапрос.УстановитьТелоИзДвоичныхДанных(ПолучитьИзВременногоХранилища(АдресХранилища));
	HttpОтвет = HttpСоединение.Записать(HTTPЗапрос);
	
	ОбработатьКодСостояния(HttpОтвет, СтруктураURL.Путь);
	
КонецПроцедуры

// Скачивает файл с Яндекс.Диска по переданному пути и возвращает адрес во временном хранилище.
//
// Параметры:
//  Путь - Строка - полнуть путь к скачиваемому файлу, например "disk:/фото/1.jpg"
// 
// Возвращаемое значение:
//  Строка - адрес во временном хранилище с полученным файлом
//
Функция СкачатьФайл(Знач Путь,СтруктураПараметров) Экспорт
	
	ИмяСервера = "cloud-api.yandex.net";
	ОтносительныйURL = "/v1/disk/resources/download?path=" + Путь;
	
	Заголовки = СформироватьЗаголовки(СтруктураПараметров);

	HttpЗапрос = Новый HTTPЗапрос(ОтносительныйURL, Заголовки);
	
	HttpСоединение = Новый HTTPСоединение(ИмяСервера, 443,,,,, Новый ЗащищенноеСоединениеOpenSSL);
	HttpОтвет = HttpСоединение.Получить(HttpЗапрос);

	ТелоОтвета = HttpОтвет.ПолучитьТелоКакСтроку(КодировкаТекста.UTF8);
	ОбработатьКодСостояния(HttpОтвет, ОтносительныйURL, ТелоОтвета);
	
	Чтение = Новый ЧтениеJSON;
	Чтение.УстановитьСтроку(ТелоОтвета);
	Ответ = ФабрикаXDTO.ПрочитатьJSON(Чтение);

	СтруктураURL = РазделитьURL(РаскодироватьСтроку(Ответ.href, СпособКодированияСтроки.КодировкаURL));
	HttpСоединение = Новый HTTPСоединение(СтруктураURL.ИмяСервера, СтруктураURL.Порт,,,,, Новый ЗащищенноеСоединениеOpenSSL);
	HttpЗапрос = Новый HTTPЗапрос(СтруктураURL.Путь);
	HttpОтвет = HttpСоединение.Получить(HttpЗапрос);
		
	// редирект
	Пока HttpОтвет.КодСостояния = 302 Цикл
		СтруктураURL = РазделитьURL(HttpОтвет.Заголовки.Получить("Location"));
		HttpСоединение = Новый HTTPСоединение(СтруктураURL.ИмяСервера, СтруктураURL.Порт,,,,, Новый ЗащищенноеСоединениеOpenSSL);
		HttpЗапрос = Новый HTTPЗапрос(СтруктураURL.Путь, Заголовки);
		HttpОтвет = HttpСоединение.Получить(HttpЗапрос);
	КонецЦикла;
	
	ОбработатьКодСостояния(HttpОтвет, СтруктураURL.Путь);
	
	ДанныеФайла = HttpОтвет.ПолучитьТелоКакДвоичныеДанные();
	Адрес = ПоместитьВоВременноеХранилище(ДанныеФайла);
	Возврат Адрес;
	
КонецФункции

// Возвращает публичну ссылку на файл или папку по переданному пути.
//
// Параметры:
//  Путь - Строка - полнуть путь к файлу или папке, например "disk:/фото/1.jpg"
// 
// Возвращаемое значение:
//  Строка - публичная ссылка на файл или папку
//
Функция ОпубликоватьПапкуИлиФайл(Знач Путь,СтруктураПараметров) Экспорт
	
	ИмяСервера = "cloud-api.yandex.net";
	ОтносительныйURL = "/v1/disk/resources/publish?path=" + Путь;
	
	Заголовки = СформироватьЗаголовки(СтруктураПараметров);

	HttpЗапрос = Новый HTTPЗапрос(ОтносительныйURL, Заголовки);
	
	HttpСоединение = Новый HTTPСоединение(ИмяСервера, 443,,,,, Новый ЗащищенноеСоединениеOpenSSL);
	HttpОтвет = HttpСоединение.Записать(HttpЗапрос);

	ТелоОтвета = HttpОтвет.ПолучитьТелоКакСтроку(КодировкаТекста.UTF8);
	ОбработатьКодСостояния(HttpОтвет, ОтносительныйURL, ТелоОтвета);
	
	Чтение = Новый ЧтениеJSON;
	Чтение.УстановитьСтроку(ТелоОтвета);
	Ответ = ФабрикаXDTO.ПрочитатьJSON(Чтение);
	
	СтруктураURL = РазделитьURL(РаскодироватьСтроку(Ответ.href, СпособКодированияСтроки.КодировкаURL));
	HttpСоединение = Новый HTTPСоединение(СтруктураURL.ИмяСервера, СтруктураURL.Порт,,,,, Новый ЗащищенноеСоединениеOpenSSL);
	HttpЗапрос = Новый HTTPЗапрос(СтруктураURL.Путь, Заголовки);
	HttpОтвет = HttpСоединение.Получить(HttpЗапрос);
	
	ТелоОтвета = HttpОтвет.ПолучитьТелоКакСтроку(КодировкаТекста.UTF8);
	ОбработатьКодСостояния(HttpОтвет, ОтносительныйURL, ТелоОтвета);
	
	Чтение = Новый ЧтениеJSON;
	Чтение.УстановитьСтроку(ТелоОтвета);
	Ответ = ФабрикаXDTO.ПрочитатьJSON(Чтение);
	
	Возврат РаскодироватьСтроку(Ответ.public_url, СпособКодированияСтроки.КодировкаURL)
	
КонецФункции

// Отменяет публикацию файла или папки по переданному пути.
//
// Параметры:
//  Путь - Строка - полнуть путь к файлу или папке, например "disk:/фото/1.jpg"
// 
Процедура ОтменитьПубликациюФайлаИлиПапки(Знач Путь,СтруктураПараметров) Экспорт
	
	ИмяСервера = "cloud-api.yandex.net";
	ОтносительныйURL = "/v1/disk/resources/unpublish?path=" + Путь;
	
	Заголовки = СформироватьЗаголовки(СтруктураПараметров);

	HttpЗапрос = Новый HTTPЗапрос(ОтносительныйURL, Заголовки);
	
	HttpСоединение = Новый HTTPСоединение(ИмяСервера, 443,,,,, Новый ЗащищенноеСоединениеOpenSSL);
	HttpОтвет = HttpСоединение.Записать(HttpЗапрос);

	ТелоОтвета = HttpОтвет.ПолучитьТелоКакСтроку(КодировкаТекста.UTF8);
	ОбработатьКодСостояния(HttpОтвет, ОтносительныйURL, ТелоОтвета);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбработатьКодСостояния(Знач HttpОтвет, Знач ОтносительныйURL, Знач ТелоОтвета = "")
	Перем ТекстИсключения;
	Если (HttpОтвет.КодСостояния < 200) Или (HttpОтвет.КодСостояния >= 300) Тогда
		ТекстИсключения = "Запрос: " + ОтносительныйURL + Символы.ПС;
		ТекстИсключения = ТекстИсключения + "Код ответа: " + HttpОтвет.КодСостояния + Символы.ПС;
		ТекстИсключения = ТекстИсключения + "Тело ответа: " + ТелоОтвета;
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
КонецПроцедуры

Функция РазделитьURL(Знач URL)
	
	ИмяСервера = "";
	Путь = "";
	Протокол = "";
	Порт = 443;
	
	URL = СокрЛП(URL);
	
	Если Лев(URL, 7) = "http://" Тогда
		URL = Прав(URL, СтрДлина(URL) - 7);
		Протокол = "http";
	ИначеЕсли Лев(URL, 8) = "https://" Тогда
		URL = Прав(URL, СтрДлина(URL) - 8);
		Протокол = "https";
	КонецЕсли;

	Индекс = СтрНайти(URL, "/");
	Если Индекс Тогда
		ИмяСервера = Лев(URL, Индекс - 1);
		Путь = Сред(URL, Индекс);
	КонецЕсли;
	
	Индекс = СтрНайти(ИмяСервера, ":");
	Если Индекс Тогда
		Порт = Число(Сред(ИмяСервера, Индекс + 1));
		ИмяСервера = Лев(ИмяСервера, Индекс - 1);
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ИмяСервера", ИмяСервера);
	Результат.Вставить("Путь", Путь);
	Результат.Вставить("Протокол", Протокол);
	Результат.Вставить("Порт", Порт);
	
	Возврат Результат;
	
КонецФункции

Функция СформироватьЗаголовки(СтруктураПараметров)
	
	Перем Заголовки;
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Accept", "application/json");
	Заголовки.Вставить("Content-Type", "application/json");
	Если ТекущаяДата() > СтруктураПараметров.СрокДействияТокена Тогда
		Токен(СтруктураПараметров);
	КонецЕсли;
	Заголовки.Вставить("Authorization", "OAuth " + СтруктураПараметров.Токен);
	Возврат Заголовки;

КонецФункции

Функция СформироватьСтруктуруПараметров(КодАвторизации = "", IDПриложения = "", ПарольПриложения = "",СрокДействияТокена = Неопределено,Токен = "") Экспорт
	
	СтруктураПараметров = Новый Структура;
	
	СтруктураПараметров.Вставить("КодАвторизации",КодАвторизации);
	СтруктураПараметров.Вставить("IDПриложения",IDПриложения);
	СтруктураПараметров.Вставить("ПарольПриложения",ПарольПриложения);
	СтруктураПараметров.Вставить("Токен",Токен);
	СтруктураПараметров.Вставить("СрокДействияТокена",?(СрокДействияТокена = Неопределено, Дата(1,1,1), СрокДействияТокена));
		
	Возврат СтруктураПараметров;

КонецФункции

Функция ПолучитьIDПриложения() Экспорт
	Возврат Константы.ЯД_ID_Приложения.Получить(); 
КонецФункции

Функция ПолучитьПарольПриложения()
	Возврат Константы.ЯД_ПарольПриложения.Получить();
КонецФункции

#КонецОбласти
