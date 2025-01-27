﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции
Функция ПолучитьФормуПоУмолчанию() Экспорт
	Возврат "";
КонецФункции

Функция СформироватьСписокЛистов(Объект) Экспорт
	Если Объект.ИмяФормы = "Форма2023_1" Тогда 
		Возврат СформироватьСписокЛистовФорма2023_1(Объект);
	КонецЕсли;
КонецФункции

Функция ПолучитьТаблицуПримененияФорматов() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуПримененияФорматов();
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2023_1";
	Стр.КНД = "1150135";
	Стр.ВерсияФормата = "5.01";
	
	Возврат Результат;
КонецФункции

Функция ДанноеУведомлениеДоступноДляОрганизации() Экспорт 
	Возврат Истина;
КонецФункции

Функция ДанноеУведомлениеДоступноДляИП() Экспорт 
	Возврат Истина;
КонецФункции

Функция ПолучитьОсновнуюФорму() Экспорт 
	Возврат "";
КонецФункции

Функция ПолучитьТаблицуФорм() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуФормУведомления();
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2023_1";
	Стр.ОписаниеФормы = "В соответствии с письмом ФНС России от 20.02.2023 № КЧ-4-8/2003@кс";
	Стр.ДатаНачала = '20230101';
	Стр.ДатаКонца = '20230815';
	
	Возврат Результат;
КонецФункции

Функция СформироватьМакет(Объект, ИмяФормы) Экспорт
	ВызватьИсключение НСтр("ru = 'Печатная форма не реализована'");
	Возврат Неопределено;
КонецФункции

Функция ЭлектронноеПредставление(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2023_1" Тогда
		Возврат ЭлектронноеПредставление_Форма2023_1(Объект, УникальныйИдентификатор);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ПроверитьДокумент(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт 
	Если ИмяФормы = "Форма2023_1" Тогда 
		Возврат ПроверитьДокументСВыводомВТаблицу_Форма2023_1(
			Объект, УведомлениеОСпецрежимахНалогообложения.ДанныеУведомленияДляВыгрузки(Объект), УникальныйИдентификатор);
	КонецЕсли;
КонецФункции

Функция ИдентификаторФайлаЭлектронногоПредставления_Форма2023_1(СведенияОтправки)
	Префикс = "UT_RASUPLSV";
	Возврат Документы.УведомлениеОСпецрежимахНалогообложения.ИдентификаторФайлаЭлектронногоПредставления(Префикс, СведенияОтправки);
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу_Форма2023_1(Объект, Данные, УникальныйИдентификатор)
	ТаблицаОшибок = Новый СписокЗначений;
	УведомлениеОСпецрежимахНалогообложения.ПроверкаАктуальностиФормыПриВыгрузке(
		Данные.Объект.ИмяФормы, ТаблицаОшибок, ПолучитьТаблицуФорм());
	УведомлениеОСпецрежимахНалогообложения.ПроверкаДатВУведомлении(Данные, ТаблицаОшибок);
	УведомлениеОСпецрежимахНалогообложения.ПолнаяПроверкаЗаполненныхПоказателейНаСоотвествиеСписку(
		"СпискиВыбора2023_1", "СхемаВыгрузкиФорма2023_1",
		Данные.Объект.ИмяОтчета, ТаблицаОшибок, Данные);
		
	ЭтоЮЛ = РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация);
	Титульная = Данные.ДанныеУведомления.Титульная;
	УведомлениеОСпецрежимахНалогообложения.ПроверкаИННКПП(ЭтоЮЛ, Титульная, ТаблицаОшибок);
	УведомлениеОСпецрежимахНалогообложения.ПроверкаКодаНО(Титульная.КодНО, ТаблицаОшибок, "Титульная");
	УведомлениеОСпецрежимахНалогообложения.ПроверкаПодписантаНалоговойОтчетности(
		Данные, ТаблицаОшибок, "Титульная", ЭтоЮЛ Или Титульная.ПРИЗНАК_НП_ПОДВАЛ = "2");
	Если Не ЗначениеЗаполнено(Титульная.НаимОрг) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не указано наименование организации / ФИО", "Титульная", "НаимОрг"));
	КонецЕсли;
	Если Титульная.ПРИЗНАК_НП_ПОДВАЛ = "2" И (Не ЗначениеЗаполнено(Титульная.НаимДок)) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Необходимо указать документ представителя", "Титульная", "НаимДок"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.ПРИЗНАК_НП_ПОДВАЛ) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не указан признак подписанта", "Титульная", "ПРИЗНАК_НП_ПОДВАЛ"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.ДАТА_ПОДПИСИ) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не указана дата подписи", "Титульная", "ДАТА_ПОДПИСИ"));
	КонецЕсли;
	
	Если ЭтоЮЛ Или Не ЗначениеЗаполнено(Титульная.Сумма) 
		Или УведомлениеОСпецрежимахНалогообложения.БлокЗаполнен(Титульная, "ПрРассрП1,ПрРассрП2,СуммаВсего") Тогда
		Если Не ЗначениеЗаполнено(Титульная.ПрРассрП1) Тогда
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не указан признак", "Титульная", "ПрРассрП1"));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Титульная.ПрРассрП2) Тогда
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не указан признак", "Титульная", "ПрРассрП2"));
		КонецЕсли;
		Если Титульная.ПрРассрП1 = "0" И Титульная.ПрРассрП2 = "0" Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Признаки не могут равняться ""0"" одновременно", "Титульная", "ПрРассрП1"));
		КонецЕсли;
	КонецЕсли;
	
	Возврат ТаблицаОшибок;
КонецФункции

Функция ОсновныеСведенияЭлектронногоПредставления_Форма2023_1(Объект, УникальныйИдентификатор)
	ОсновныеСведения = Документы.УведомлениеОСпецрежимахНалогообложения.НачальнаяИнициализацияОбщихРеквизитовВыгрузки(Объект);
	Данные = Объект.ДанныеУведомления.Получить();
	ИдентификаторФайла = ИдентификаторФайлаЭлектронногоПредставления_Форма2023_1(ОсновныеСведения);
	ОсновныеСведения.Вставить("ИдФайл", ИдентификаторФайла);
	
	Возврат ОсновныеСведения;
КонецФункции

Функция ЭлектронноеПредставление_Форма2023_1(Объект, УникальныйИдентификатор)
	СведенияЭлектронногоПредставления = УведомлениеОСпецрежимахНалогообложения.СведенияЭлектронногоПредставления();
	ДанныеУведомления = УведомлениеОСпецрежимахНалогообложения.ДанныеУведомленияДляВыгрузки(Объект);
	Ошибки = ПроверитьДокументСВыводомВТаблицу_Форма2023_1(Объект, ДанныеУведомления, УникальныйИдентификатор);
	УведомлениеОСпецрежимахНалогообложения.СообщитьОшибкиПриПроверкеВыгрузки(Объект, Ошибки, ДанныеУведомления);
	
	ОсновныеСведения = ОсновныеСведенияЭлектронногоПредставления_Форма2023_1(Объект, УникальныйИдентификатор);
	СтруктураВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2023_1");
	УведомлениеОСпецрежимахНалогообложения.ТиповоеЗаполнениеДанными(ДанныеУведомления, ОсновныеСведения, СтруктураВыгрузки);
	УведомлениеОСпецрежимахНалогообложения.ВыгрузитьДеревоВТаблицу(СтруктураВыгрузки, ОсновныеСведения, СведенияЭлектронногоПредставления);
	Возврат СведенияЭлектронногоПредставления;
КонецФункции

Функция СформироватьСписокЛистовФорма2023_1(Объект) Экспорт
	Листы = Новый СписокЗначений;
	
	МакетУведомления = Отчеты[Объект.ИмяОтчета].ПолучитьМакет("Печать_Форма2023_1_Титульная");
	ЭтоЮЛ = РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация);
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
	СтруктураПараметров = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Ссылка, "ДанныеУведомления").Получить();
	Титульная = СтруктураПараметров.ДанныеУведомления.Титульная;
	ИННКПП = УведомлениеОСпецрежимахНалогообложения.ТиповаяСтруктураИННКППДляПечати(Объект, Титульная);
	Для Каждого КЗ Из Титульная Цикл
		ИННКПП.Вставить(КЗ.Ключ, КЗ.Значение);
	КонецЦикла;
	Если ЭтоЮЛ Тогда
		ИННКПП.Вставить("ОписаниеОрганизации", Титульная.НаимОрг + " ИНН/КПП " + Титульная.ИНН + "/" + Титульная.КПП);
	Иначе
		ИННКПП.Вставить("ОписаниеОрганизации", Титульная.НаимОрг + " ИНН " + Титульная.ИНН);
	КонецЕсли;
	ИННКПП.Вставить("СуммаВсего", Формат(Титульная.СуммаВсего, "ЧН=_____; ЧГ="));
	ИННКПП.Вставить("Сумма", Формат(Титульная.Сумма, "ЧН=_____; ЧГ="));
	
	ОбластьЧасть = МакетУведомления.ПолучитьОбласть("ОсновнаяЧасть");
	ЗаполнитьЗначенияСвойств(ОбластьЧасть.Параметры, ИННКПП);
	ПечатнаяФорма.Вывести(ОбластьЧасть);
	
	УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, 1, Ложь);
	Возврат Листы;
КонецФункции

#КонецОбласти
#КонецЕсли
