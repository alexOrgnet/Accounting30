﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
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
	Стр.ИмяФормы = "ИсключениеИзРеестра";
	Стр.ОписаниеФормы = "Печатный бланк в соответствии с приказом Федеральной службы по регулированию алкогольного рынка от 20 июля 2023 г. № 213";
	Стр.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ИсключениеИзРеестраПроизводителейПива;
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "ВключениеИзменениеВРеестр";
	Стр.ОписаниеФормы = "Печатный бланк в соответствии с приказом Федеральной службы по регулированию алкогольного рынка от 20 июля 2023 г. № 213";
	Стр.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ВключениеВРеестрПроизводителейПива;
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "ВключениеИзменениеВРеестр";
	Стр.ОписаниеФормы = "Печатный бланк в соответствии с приказом Федеральной службы по регулированию алкогольного рынка от 20 июля 2023 г. № 213";
	Стр.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ВнесениеИзмененийВРеестрПроизводителейПива;
	
	Возврат Результат;
КонецФункции

Функция ЭлектронноеПредставление(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении(
		"Для данного заявления выгрузка не предусмотрена", УникальныйИдентификатор);
	ВызватьИсключение "";
КонецФункции

Функция ПолучитьИмяПечатнойФормы(Объект)
	Возврат СоответствиеПечатнойФормыПоВиду()[Объект.ВидУведомления];
КонецФункции

Функция СоответствиеПечатнойФормыПоВиду()
	Результат = Новый Соответствие;
	Результат.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ИсключениеИзРеестраПроизводителейПива, "Печать_MXL_ИсключениеИзРеестраПроизводителейПива");
	Результат.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ВключениеВРеестрПроизводителейПива, "Печать_MXL_ВключениеВРеестрПроизводителейПива");
	Результат.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ВнесениеИзмененийВРеестрПроизводителейПива, "Печать_MXL_ВнесениеИзмененийВРеестрПроизводителейПива");
	Возврат Результат;
КонецФункции

Функция ПолучитьНазваниеОргана(Объект) Экспорт
	Если Объект.ИмяФормы = "ФормаУведомления" Тогда
		СтруктураПараметров = Объект.ДанныеУведомления.Получить();
		Титульный = СтруктураПараметров.Титульный[0];
		Возврат Титульный.Орган;
	КонецЕсли;
	Возврат "";
КонецФункции

Функция СформироватьСписокЛистов(Объект) Экспорт
	Если Объект.ИмяФормы = "ИсключениеИзРеестра" Тогда
		Возврат СформироватьСписокЛистовФормаУведомления(Объект);
	ИначеЕсли Объект.ИмяФормы = "ВключениеИзменениеВРеестр" Тогда
		Возврат СформироватьСписокЛистов_ВключениеИзменениеВРеестрПроизводителейПива(Объект);
	Иначе
		Возврат УведомлениеОСпецрежимахНалогообложения.ПечатьВСледующихВерсиях(Объект);
	КонецЕсли;
КонецФункции

Функция СформироватьСписокЛистов_ВключениеИзменениеВРеестрПроизводителейПива(Объект) Экспорт
	Листы = Новый СписокЗначений;
	МакетУведомления = Отчеты[Объект.ИмяОтчета].ПолучитьМакет(ПолучитьИмяПечатнойФормы(Объект));
	ДанныеУведомления = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Ссылка, "ДанныеУведомления").Получить();
	Титульный = ДанныеУведомления.ДанныеУведомления.Титульная;
	
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
	ПечатнаяФорма.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	
	ОбластьЧасть = МакетУведомления.ПолучитьОбласть("Часть1");
	ЗаполнитьЗначенияСвойств(ОбластьЧасть.Параметры, Титульный);
	ПечатнаяФорма.Вывести(ОбластьЧасть);
	Для Каждого Стр Из ДанныеУведомления.ДанныеМногостраничныхРазделов.Подразделение Цикл 
		Подразделение = Стр.Значение;
		Если УведомлениеОСпецрежимахНалогообложения.СтраницаЗаполнена(Подразделение)
			Или ДанныеУведомления.ДанныеМногостраничныхРазделов.Подразделение.Количество() = 1 Тогда 
			
			ОбластьЧасть = МакетУведомления.ПолучитьОбласть("Часть2");
			ЗаполнитьЗначенияСвойств(ОбластьЧасть.Параметры, Подразделение);
			ПечатнаяФорма.Вывести(ОбластьЧасть);
		КонецЕсли;
	КонецЦикла;
	ОбластьЧасть = МакетУведомления.ПолучитьОбласть("Часть3");
	ЗаполнитьЗначенияСвойств(ОбластьЧасть.Параметры, Титульный);
	ПечатнаяФорма.Вывести(ОбластьЧасть);
	
	УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, 1, Ложь);
	Возврат Листы;
КонецФункции

Функция СформироватьСписокЛистовФормаУведомления(Объект) Экспорт
	Листы = Новый СписокЗначений;
	МакетУведомления = Отчеты[Объект.ИмяОтчета].ПолучитьМакет(ПолучитьИмяПечатнойФормы(Объект));
	Титульный = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Ссылка, "ДанныеУведомления").Получить().Титульный;
	Инд = 0;
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
	ПечатнаяФорма.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	НомСтр = 1;
	Пока Истина Цикл 
		Инд = Инд + 1;
		Если МакетУведомления.Области.Найти("Часть" + Формат(Инд, "ЧГ=")) = Неопределено Тогда 
			Прервать;
		КонецЕсли;
		ОбластьЧасть = МакетУведомления.ПолучитьОбласть("Часть" + Формат(Инд, "ЧГ="));
		ЗаполнитьЗначенияСвойств(ОбластьЧасть.Параметры, Титульный);
		ПечатнаяФорма.Вывести(ОбластьЧасть);
	КонецЦикла;
	УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр, Ложь);
	Возврат Листы;
КонецФункции

Процедура ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр, Название) Экспорт 
	Лист = Новый Массив;
	Лист.Добавить(ПоместитьВоВременноеХранилище(ПечатнаяФорма));
	Лист.Добавить(Новый УникальныйИдентификатор);
	Лист.Добавить(Название);
	Листы.Добавить(Лист, Название);
	
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
КонецПроцедуры

#КонецОбласти
#КонецЕсли