﻿
Процедура ЗаполнитьСписокВыбораВидовПредприятия(Элемент) Экспорт

	ТаблицаВидовДеятельности = ПрочиеКлассификаторыВЕТИСВызовСервера.ВидыДеятельностиПредприятий();
	ТаблицаВидовДеятельности.Сортировать("Наименование");
	
	Для Каждого СтрокаТаблицы Из ТаблицаВидовДеятельности Цикл
		
		ПредставлениеВида = ?(СтрДлина(СтрокаТаблицы.Наименование) < 91, СтрокаТаблицы.Наименование, Лев(СтрокаТаблицы.Наименование, 90) + "...");
		Элемент.СписокВыбора.Добавить(СтрокаТаблицы.Наименование, ПредставлениеВида);
		
	КонецЦикла;

КонецПроцедуры

Процедура ЗаполнитьСписокВыбораОрганизационноПравовыхФорм(Элемент) Экспорт

	ТаблицаОПФ = ПрочиеКлассификаторыВЕТИСВызовСервера.ОрганизационноПравовыеФормы();
	ТаблицаОПФ.Сортировать("Наименование");
	
	Для Каждого СтрокаТаблицы Из ТаблицаОПФ Цикл
		
		ПредставлениеОПФ = ?(СтрДлина(СтрокаТаблицы.Наименование) < 81, СтрокаТаблицы.Наименование, Лев(СтрокаТаблицы.Наименование, 80) + "...");
		ПредставлениеОПФ = СтрШаблон("%1 (%2)", ПредставлениеОПФ, СтрокаТаблицы.Код);
		
		Элемент.СписокВыбора.Добавить(СтрокаТаблицы.GUID , ПредставлениеОПФ);
		
	КонецЦикла;

КонецПроцедуры

Функция ТекстОшибкиПолученияДанных(ТекстОшибки) Экспорт
	
	Строки = Новый Массив;
	Строки.Добавить(
	Новый ФорматированнаяСтрока(
	НСтр("ru = 'Ошибка:'")));
	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(ТекстОшибки,, ЦветаСтиля.ЦветТекстаПроблемаГосИС));
	
	Возврат Новый ФорматированнаяСтрока(Строки);
	
КонецФункции

Функция ПодключенныеХозяйствующиеСубъектыДокумента(Документ) Экспорт

	Если Не ЗначениеЗаполнено(Документ) Тогда
		Возврат Новый Массив;
	КонецЕсли;
	
	СписокРеквизитов = Неопределено;
	
	Если ТипЗнч(Документ) = Тип("ДокументСсылка.ИсходящаяТранспортнаяОперацияВЕТИС") Тогда
		
		СписокРеквизитов = "ГрузоотправительХозяйствующийСубъект, ГрузополучательХозяйствующийСубъект";
		
	ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.ЗапросСкладскогоЖурналаВЕТИС") Тогда
		
		СписокРеквизитов = "ХозяйствующийСубъект";
		
	ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.ПроизводственнаяОперацияВЕТИС") Тогда

		СписокРеквизитов = "ХозяйствующийСубъект";
		
	ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.ВходящаяТранспортнаяОперацияВЕТИС") Тогда

		СписокРеквизитов = "ГрузоотправительХозяйствующийСубъект, ГрузополучательХозяйствующийСубъект";
		
	ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.ИнвентаризацияПродукцииВЕТИС") Тогда

		СписокРеквизитов = "ХозяйствующийСубъект";
		
	ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.ОбъединениеЗаписейСкладскогоЖурналаВЕТИС") Тогда
		
		СписокРеквизитов = "ХозяйствующийСубъект";
		
	КонецЕсли;
	
	Если СписокРеквизитов = Неопределено Тогда
		ЗначенияХозяйствующихСубъектов = Новый Структура;
	Иначе
		ЗначенияХозяйствующихСубъектов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Документ, СписокРеквизитов);
	КонецЕсли;
	
	МассивХозяйствующихСубъектов = Новый Массив;
	
	Для Каждого ЭлементСтруктуры Из ЗначенияХозяйствующихСубъектов Цикл
		
		Если ЗначениеЗаполнено(ЭлементСтруктуры.Значение)
			И МассивХозяйствующихСубъектов.Найти(ЭлементСтруктуры.Значение) = Неопределено Тогда
			
			МассивХозяйствующихСубъектов.Добавить(ЭлементСтруктуры.Значение);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	НастройкиПодключенияВЕТИС.ХозяйствующийСубъект КАК ХозяйствующийСубъект
	|ИЗ
	|	РегистрСведений.НастройкиПодключенияВЕТИС КАК НастройкиПодключенияВЕТИС
	|ГДЕ
	|	НастройкиПодключенияВЕТИС.ХозяйствующийСубъект В(&МассивХозяйствующихСубъектов)";
	
	Запрос.УстановитьПараметр("МассивХозяйствующихСубъектов", МассивХозяйствующихСубъектов);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ХозяйствующийСубъект");
	
КонецФункции
