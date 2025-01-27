﻿// Расширение EnterpriseData позволяет в случае крайней необходимости расширить стандарт:
// до публикации очередной версии стандарта добавить в объект дополнительные, согласованные обеими сторонами обмена данные.

#Область ПрограммныйИнтерфейс

// Конструктор манифеста расширения - общего описания соглашения о расширении стандарта EnterpriseData
//
// Возвращаемое значение:
//  Структура - см. тело функции
//
Функция НовыйМанифестРасширения() Экспорт
	
	Манифест = Новый Структура;
	Манифест.Вставить("Имя",                          "");
	Манифест.Вставить("ИменаСвойствСоЗначениямиДата", Новый Массив);
	
	Возврат Манифест;
	
КонецФункции

// Получает данные расширения из результата десериализации сообщения в формате EnterpriseData средствами XDTO.
// 
// Данные расширения содержатся в сериализованном виде (т.е. как пришли от отправителя сообщения) в свойстве объекта AdditionalInfo
// (см. тип Object пространства http://www.1c.ru/SSL/Exchange/Message).
//
// Свойство AdditionalInfo объекта должно содержать json-строку с объектом enterprisedata_extension:
//   * "extension" : enum   - идентификатор соглашения о расширении стандарта ED - см. Имя в манифесте расширения
//   * "info"      : object - данные, в формате определенном соглашением
// 
// Параметры:
//  ДанныеXDTO			 - Структура - результат десериализации средствами XDTO объекта сообщения в формате EnterpriseData
//  МанифестРасширения	 - Структура - см. НовыйМанифестРасширения, описание расширения
//  КомпонентыОбмена	 - Структура - см. ОбменДаннымиXDTOСервер.ИнициализироватьКомпонентыОбмена, процессор обмена EnterpriseData
// 
// Возвращаемое значение:
//  Соответствие, Массив - десериализованные данные в формате, определенном соглашением 
//  Неопределено - отсутствуют данные в формате, определенном соглашением
//
Функция ДанныеРасширения(ДанныеXDTO, МанифестРасширения, КомпонентыОбмена) Экспорт
	
	Если ПустаяСтрока(МанифестРасширения.Имя) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ИмяСвойстваРасширений = ИмяСвойстваРасширенийED();
	
	Если Не ДанныеXDTO.Свойство(ИмяСвойстваРасширений)
		Или Не ЗначениеЗаполнено(ДанныеXDTO[ИмяСвойстваРасширений]) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	// При этом вызове предполагается, что в свойстве ДанныеXDTO хранятся данные в виде json-строки
	// (т.е. как пришли от отправителя сообщения).
	// В результате работы функции данные десериализуются.
	// Десериализованные данные могут понадобиться в разных обработчиках механизма EnterpriseData.
	// Для того, чтобы не десериализовывать повторно, их можно передать в более поздние обработчики
	// через то же свойство объекта ДанныеXDTO - заменив в нем сериализованные данные на десериализованные.
	// Для этого следует использовать метод УстановитьДесериализованныеДанныеРасширения().
	СериализованныйКонтейнерРасширения = ДанныеXDTO[ИмяСвойстваРасширений];
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(СериализованныйКонтейнерРасширения);
	
	Попытка
	
		РасширениеED = ПрочитатьJSON(ЧтениеJSON, Истина, МанифестРасширения.ИменаСвойствСоЗначениямиДата);
		
	Исключение
		
		ЗаписатьПредупреждениеРасширенияED(
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
			СериализованныйКонтейнерРасширения,
			МанифестРасширения,
			КомпонентыОбмена);
		
		Возврат Неопределено;
		
	КонецПопытки;
	
	Если ТипЗнч(РасширениеED) <> Тип("Соответствие") Тогда
		ЗаписатьПредупреждениеРасширенияED(
			НСтр("ru = 'Верхний уровень структуры данных не содержит объект.'", Метаданные.ОсновнойЯзык.КодЯзыка),
			СериализованныйКонтейнерРасширения,
			МанифестРасширения,
			КомпонентыОбмена);
		Возврат Неопределено;
	КонецЕсли;
	
	Если РасширениеED["extension"] <> МанифестРасширения.Имя Тогда
		ЗаписатьПредупреждениеРасширенияED(
			НСтр("ru = 'Свойство ""extension"" не содержит имя расширения.'", Метаданные.ОсновнойЯзык.КодЯзыка),
			СериализованныйКонтейнерРасширения,
			МанифестРасширения,
			КомпонентыОбмена);
		Возврат Неопределено;
	КонецЕсли;
		
	ДанныеРасширения = РасширениеED["info"];
	
	Если ДанныеРасширения = Неопределено Тогда
		ЗаписатьПредупреждениеРасширенияED(
			НСтр("ru = 'Свойство ""info"" не содержит данных.'", Метаданные.ОсновнойЯзык.КодЯзыка),
			СериализованныйКонтейнерРасширения,
			МанифестРасширения,
			КомпонентыОбмена);
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ДанныеРасширения;
	
КонецФункции

// Помещает десериализованные данные расширения в объект EnterpriseData для дальнейшей обработки в правиле конвертации объекта.
// Целесообразно применять, если правилом обработки данных в зависимости от наличия расширения "включается" особое правило конвертации объекта.
//
// Параметры:
//  ДанныеXDTO       - Структура - результат десериализации средствами XDTO объекта сообщения в формате EnterpriseData
//  ДанныеРасширения - Массив, Соответствие - результат ДанныеРасширения()
//
Процедура УстановитьДесериализованныеДанныеРасширения(ДанныеXDTO, ДанныеРасширения) Экспорт
	
	ДанныеXDTO.Вставить(ИмяСвойстваРасширенийED(), ДанныеРасширения);
	
КонецПроцедуры

// Извлекает данные, десериализованные ранее методом ДанныеРасширения() и помещенные методом УстановитьДанныеРасширения()
//
// Параметры:
//  ДанныеXDTO - Структура - результат десериализации средствами XDTO объекта сообщения в формате EnterpriseData
//
// Возвращаемое значение:
//  Массив, Соответствие - результат ДанныеРасширения()
//
Функция ДесериализованныеДанныеРасширения(ДанныеXDTO) Экспорт
	
	Возврат ДанныеXDTO[ИмяСвойстваРасширенийED()];
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ДополнитьЗагруженныеОбъекты(КомпонентыОбмена, Ссылка, Объект = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект = Неопределено Тогда
		Объект = Ссылка.ПолучитьОбъект();
	КонецЕсли;
	
	НоваяСтрока = КомпонентыОбмена.ЗагруженныеОбъекты.Добавить();
	НоваяСтрока.Объект         = Объект;
	НоваяСтрока.СсылкаНаОбъект = Ссылка;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Функция ИмяСвойстваРасширенийED()
	Возврат "AdditionalInfo";
КонецФункции

Процедура ЗаписатьПредупреждениеРасширенияED(ТекстОшибки, СериализованныйКонтейнерРасширения, МанифестРасширения, КомпонентыОбмена)
	
	ШаблонТекстаОшибки = НСтр("ru = 'Свойство %1 содержит данные, не соответствующие расширению %2.
                               |Текст ошибки:
                               |%3
                               |Значение свойства:
                               |%4'", Метаданные.ОсновнойЯзык.КодЯзыка);
	
	ТекстОшибки = СтрШаблон(
		ШаблонТекстаОшибки,
		ИмяСвойстваРасширенийED(),
		МанифестРасширения.Имя,
		ТекстОшибки,
		СериализованныйКонтейнерРасширения);
	
	ЗаписьЖурналаРегистрации(КомпонентыОбмена.КлючСообщенияЖурналаРегистрации, УровеньЖурналаРегистрации.Предупреждение, , , ТекстОшибки);
	
КонецПроцедуры

#КонецОбласти
