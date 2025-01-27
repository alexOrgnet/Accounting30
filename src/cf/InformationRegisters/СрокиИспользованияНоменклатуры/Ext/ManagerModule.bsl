﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикОбновленияИнформационнойБазыБП

Процедура ЗаполнитьСрокиИспользованияНоменклатуры() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НазначенияИспользования.Владелец КАК Номенклатура,
	|	МАКСИМУМ(НазначенияИспользования.СрокПолезногоИспользования) КАК СрокИспользования
	|ПОМЕСТИТЬ СрокиПоНазначениюИспользования
	|ИЗ
	|	Справочник.НазначенияИспользования КАК НазначенияИспользования
	|ГДЕ
	|	НазначенияИспользования.СрокПолезногоИспользования > 0
	|	И НЕ НазначенияИспользования.ПометкаУдаления
	|	И НЕ НазначенияИспользования.Владелец ЕСТЬ NULL
	|	И НЕ НазначенияИспользования.Владелец = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	НазначенияИспользования.Владелец
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(СрокиПоНазначениюИспользования.Номенклатура, СрокиИспользованияНоменклатуры.Номенклатура) КАК Номенклатура,
	|	ЕСТЬNULL(СрокиИспользованияНоменклатуры.СрокИспользования, СрокиПоНазначениюИспользования.СрокИспользования) КАК СрокИспользования
	|ИЗ
	|	СрокиПоНазначениюИспользования КАК СрокиПоНазначениюИспользования
	|		ПОЛНОЕ СОЕДИНЕНИЕ РегистрСведений.СрокиИспользованияНоменклатуры КАК СрокиИспользованияНоменклатуры
	|		ПО СрокиПоНазначениюИспользования.Номенклатура = СрокиИспользованияНоменклатуры.Номенклатура";
	
	ТаблицаСроковИспользованияНоменклатуры = Запрос.Выполнить().Выгрузить();
	
	НаборЗаписей = РегистрыСведений.СрокиИспользованияНоменклатуры.СоздатьНаборЗаписей();
	НаборЗаписей.Загрузить(ТаблицаСроковИспользованияНоменклатуры);
	
	Попытка
		ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
		
	Исключение
		ШаблонСообщения = НСтр("ru = 'Не удалось записать данные регистра Сроки использования номенклатуры
                               |%1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(
			ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), 
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ТекстСообщения);
			
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли