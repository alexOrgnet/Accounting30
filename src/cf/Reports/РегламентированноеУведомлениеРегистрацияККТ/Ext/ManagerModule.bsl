﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ПолучитьТаблицуПримененияФорматов() Экспорт 
	Возврат Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуПримененияФорматов();
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

Функция ПолучитьФормуПоУмолчанию() Экспорт 
	Возврат "";
КонецФункции

Функция ПолучитьТаблицуФорм() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуФормУведомления();
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2023_1";
	Стр.ОписаниеФормы = "В соответствии с приказом ФНС России от 08.09.2021 N ЕД-7-20/799@";
	
	Возврат Результат;
КонецФункции

Функция ЭлектронноеПредставление(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	ОбщегоНазначения.СообщитьПользователю("Выгрузка в электронном виде не предусмотрена");
КонецФункции

Функция ПроверитьДокумент(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
КонецФункции

Функция СформироватьСписокЛистов(Объект) Экспорт
	Если Объект.ИмяФормы = "Форма2023_1" Тогда 
		Возврат СформироватьСписокЛистовФорма2023_1(Объект);
	КонецЕсли;
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт 
	ОбщегоНазначения.СообщитьПользователю("Выгрузка в электронном виде не предусмотрена");
КонецФункции

Функция СформироватьСписокЛистовФорма2023_1(Объект) Экспорт
	Листы = Новый СписокЗначений;
	
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
	СтруктураПараметров = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Ссылка, "ДанныеУведомления").Получить();
	ИННКПП = УведомлениеОСпецрежимахНалогообложения.ТиповаяСтруктураИННКППДляПечати(Объект, СтруктураПараметров.ДанныеУведомления.Титульная);
	ИННКПП.Вставить("ОГРНШапка", СтруктураПараметров.ДанныеУведомления.Титульная.ОГРН);
	ИННКПП.Вставить("ДолжностьПредставление", СтруктураПараметров.ДанныеУведомления.Титульная.ДолжностьПредставление);
	ИННКПП.Вставить("ФИОПредставление", СтруктураПараметров.ДанныеУведомления.Титульная.ФИОПредставление);
	
	НомСтр = 0;
	УведомлениеОСпецрежимахНалогообложения.НапечататьСтруктуру(Объект.ИмяОтчета, СтруктураПараметров.ДанныеУведомления["Титульная"],
		НомСтр, "Печать_Форма2023_1_Титульная_1", ПечатнаяФорма, ИННКПП);
	УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
	УведомлениеОСпецрежимахНалогообложения.НапечататьСтруктуру(Объект.ИмяОтчета, СтруктураПараметров.ДанныеУведомления["Титульная"],
		НомСтр, "Печать_Форма2023_1_Титульная_2", ПечатнаяФорма, ИННКПП);
	УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
	
	УведомлениеОСпецрежимахНалогообложения.НапечататьСтруктуру(Объект.ИмяОтчета, СтруктураПараметров.ДанныеУведомления["Раздел1"],
		НомСтр, "Печать_Форма2023_1_Раздел1_1", ПечатнаяФорма, ИННКПП);
	УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
	УведомлениеОСпецрежимахНалогообложения.НапечататьСтруктуру(Объект.ИмяОтчета, СтруктураПараметров.ДанныеУведомления["Раздел1"],
		НомСтр, "Печать_Форма2023_1_Раздел1_2", ПечатнаяФорма, ИННКПП);
	УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
	
	УведомлениеОСпецрежимахНалогообложения.НапечататьСтруктуру(Объект.ИмяОтчета, СтруктураПараметров.ДанныеУведомления["Раздел2"],
		НомСтр, "Печать_Форма2023_1_Раздел2_1", ПечатнаяФорма, ИННКПП);
	УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
	УведомлениеОСпецрежимахНалогообложения.НапечататьСтруктуру(Объект.ИмяОтчета, СтруктураПараметров.ДанныеУведомления["Раздел2"],
		НомСтр, "Печать_Форма2023_1_Раздел2_2", ПечатнаяФорма, ИННКПП);
	УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
	
	Для Каждого Стр Из СтруктураПараметров.ДанныеМногостраничныхРазделов["Раздел21"] Цикл 
		УведомлениеОСпецрежимахНалогообложения.НапечататьСтруктуру(Объект.ИмяОтчета, Стр.Значение,
			НомСтр, "Печать_Форма2023_1_Раздел21", ПечатнаяФорма, ИННКПП);
		УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
	КонецЦикла;
	
	Если УведомлениеОСпецрежимахНалогообложения.СтраницаЗаполнена(СтруктураПараметров.ДанныеУведомления["Раздел3"]) Тогда 
		УведомлениеОСпецрежимахНалогообложения.НапечататьСтруктуру(Объект.ИмяОтчета, СтруктураПараметров.ДанныеУведомления["Раздел3"],
			НомСтр, "Печать_Форма2023_1_Раздел3", ПечатнаяФорма, ИННКПП);
		УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
	КонецЕсли;
	
	УведомлениеОСпецрежимахНалогообложения.НапечататьСтруктуру(Объект.ИмяОтчета, СтруктураПараметров.ДанныеУведомления["Раздел4"],
		НомСтр, "Печать_Форма2023_1_Раздел4", ПечатнаяФорма, ИННКПП);
	УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
	Возврат Листы;
КонецФункции

#КонецОбласти
#КонецЕсли
