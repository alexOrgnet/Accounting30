﻿#Область СлужебныйПрограммныйИнтерфейс

Процедура НаименованиеДокументаПриИзмененииНаСервере(Организация, ВидДокумента, НаименованиеДокумента) Экспорт
	
	ЭлектронныеТрудовыеКнижки.НаименованиеДокументаПриИзмененииНаСервере(Организация, ВидДокумента, НаименованиеДокумента);
	
КонецПроцедуры

Функция НаименованиеДокумента(Организация, ВидМероприятия = Неопределено) Экспорт
	
	Если ВидМероприятия = Перечисления.ВидыМероприятийТрудовойДеятельности.Прием Тогда
		Возврат ЭлектронныеТрудовыеКнижки.НаименованиеДокументаПоВидуДокументаСобытия(Организация, "ПриемНаРаботу");
	ИначеЕсли ВидМероприятия = Перечисления.ВидыМероприятийТрудовойДеятельности.Перевод Тогда
		Возврат ЭлектронныеТрудовыеКнижки.НаименованиеДокументаПоВидуДокументаСобытия(Организация, "КадровыйПеревод");
	ИначеЕсли ВидМероприятия = Перечисления.ВидыМероприятийТрудовойДеятельности.Увольнение Тогда
		Возврат ЭлектронныеТрудовыеКнижки.НаименованиеДокументаПоВидуДокументаСобытия(Организация, "Увольнение");
	КонецЕсли;
	
	Возврат ЭлектронныеТрудовыеКнижки.НаименованиеДокументаОснования();
	
КонецФункции

Функция НеЗаполнятьПодразделенияВМероприятияхТрудовойДеятельности(Организация) Экспорт
	
	Возврат ЭлектронныеТрудовыеКнижкиПовтИсп.НеЗаполнятьПодразделенияВМероприятияхТрудовойДеятельности(Организация);
	
КонецФункции

Функция НомерНаПечать(Знач Номер, Знач НомерПриказа = Неопределено) Экспорт
	
	Возврат ЗарплатаКадрыОтчеты.НомерНаПечать(Номер, НомерПриказа);
	
КонецФункции

Функция ИспользоватьДляМероприятийПриемПереводУвольнениеДваДокументаОснования() Экспорт
	
	Возврат ЭлектронныеТрудовыеКнижкиПовтИсп.НастройкиЭлектронныхТрудовыхКнижек().ИспользоватьДляМероприятийПриемПереводУвольнениеДваДокументаОснования;
	
КонецФункции

Функция ДанныеФайловСТДР(СсылкаНаДокумент, ИдентификаторХранилища) Экспорт
	
	Возврат Документы.СведенияОТрудовойДеятельностиРаботникаСТД_Р.ДанныеФайловСТДР(СсылкаНаДокумент, ИдентификаторХранилища);
	
КонецФункции

Процедура ОбновитьФайлСТДР(СсылкаНаДокумент, АдресВХранилище, ИмяФайла, ПрисоединенныйФайл) Экспорт
	
	Если ЗначениеЗаполнено(ПрисоединенныйФайл) Тогда
		
		ИнформацияОФайле = Новый Структура;
		ИнформацияОФайле.Вставить("ДатаМодификацииУниверсальная", ТекущаяУниверсальнаяДата());
		ИнформацияОФайле.Вставить("АдресФайлаВоВременномХранилище", АдресВХранилище);
		ИнформацияОФайле.Вставить("АдресВременногоХранилищаТекста", "");
		ИнформацияОФайле.Вставить("Расширение", "XML");
		ИнформацияОФайле.Вставить("ИмяБезРасширения", ИмяФайла);
		
		РаботаСФайлами.ОбновитьФайл(ПрисоединенныйФайл, ИнформацияОФайле);
		
	Иначе
		
		ПараметрыФайла = РаботаСФайлами.ПараметрыДобавленияФайла();
		
		ПараметрыФайла.ВладелецФайлов = СсылкаНаДокумент;
		ПараметрыФайла.ИмяБезРасширения = ИмяФайла;
		ПараметрыФайла.РасширениеБезТочки = "XML";
		ПараметрыФайла.ВремяИзмененияУниверсальное = ТекущаяУниверсальнаяДата();
		
		ПрисоединенныйФайл = РаботаСФайлами.ДобавитьФайл(ПараметрыФайла, АдресВХранилище, "");
		
	КонецЕсли;
	
КонецПроцедуры

Функция ИмяОбъектаМетаданных(СсылкаНаОбъект) Экспорт
	
	Возврат СсылкаНаОбъект.Метаданные().Имя;
	
КонецФункции

Функция СертификатОрганизации(Организация) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());
	Запрос.УстановитьПараметр("ДействителенДо", НачалоДня(ТекущаяДатаСеанса()));
	
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СертификатыКлючейЭлектроннойПодписиИШифрования.Ссылка КАК Ссылка,
		|	СертификатыКлючейЭлектроннойПодписиИШифрования.Отпечаток КАК Отпечаток,
		|	СертификатыКлючейЭлектроннойПодписиИШифрования.ДанныеСертификата КАК ДанныеСертификата
		|ИЗ
		|	Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования КАК СертификатыКлючейЭлектроннойПодписиИШифрования
		|ГДЕ
		|	СертификатыКлючейЭлектроннойПодписиИШифрования.Организация = &Организация
		|	И СертификатыКлючейЭлектроннойПодписиИШифрования.Пользователь = &Пользователь
		|	И СертификатыКлючейЭлектроннойПодписиИШифрования.Подписание
		|	И НЕ СертификатыКлючейЭлектроннойПодписиИШифрования.Отозван
		|	И СертификатыКлючейЭлектроннойПодписиИШифрования.ДействителенДо >= &ДействителенДо
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ДанныеСертификата.Получить();
	КонецЕсли;
	
КонецФункции

Функция ОтражениеВТрудовойКнижкеСовместительств() Экспорт
	
	Возврат ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ЭлектронныеТрудовыеКнижки", "ОтражениеВТрудовойКнижке", Ложь);
	
КонецФункции

Процедура ЗапомнитьОтражениеВТрудовойКнижкеСовместительств(ОтражениеВТрудовойКнижке) Экспорт
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ЭлектронныеТрудовыеКнижки", "ОтражениеВТрудовойКнижке", ОтражениеВТрудовойКнижке);
	
КонецПроцедуры

#КонецОбласти
