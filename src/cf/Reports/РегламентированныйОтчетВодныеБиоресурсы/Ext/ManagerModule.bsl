﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВерсияФорматаВыгрузки(Знач НаДату = Неопределено, ВыбраннаяФорма = Неопределено) Экспорт
	
	Если НаДату = Неопределено Тогда
		НаДату = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если НаДату > '20100901' Тогда
		Возврат Перечисления.ВерсииФорматовВыгрузки.Версия500;
	ИначеЕсли НаДату > '20050101' Тогда
		Возврат Перечисления.ВерсииФорматовВыгрузки.Версия300;
	КонецЕсли;
	
КонецФункции

Функция ТаблицаФормОтчета() Экспорт
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(0));
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Дата"));
	ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));
	
	ТаблицаФормОтчета = Новый ТаблицаЗначений;
	ТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
	ТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, "Утверждена",  20);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   "Действует с", 5);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   "         по", 5);
	ТаблицаФормОтчета.Колонки.Добавить("РедакцияФормы",      ОписаниеТиповСтрока, "Редакция формы", 20);
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2024Кв1";
	НоваяФорма.ОписаниеОтчета     = "Приказ ФНС России от 17.11.2023 № ЕД-7-3/853@.";
	НоваяФорма.РедакцияФормы      = "от 17.11.2023 № ЕД-7-3/853@.";
	НоваяФорма.ДатаНачалоДействия = '2024-02-01';
	НоваяФорма.ДатаКонецДействия  = РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата"));
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2017Кв4";
	НоваяФорма.ОписаниеОтчета     = "Приказ ФНС России от 14.06.2017 № ММВ-7-3/505@.";
	НоваяФорма.РедакцияФормы      = "от 14.06.2017 № ММВ-7-3/505@.";
	НоваяФорма.ДатаНачалоДействия = '2017-11-01';
	НоваяФорма.ДатаКонецДействия  = '2024-12-31';
	
	Возврат ТаблицаФормОтчета;
	
КонецФункции

Функция ДеревоФормИФорматов() Экспорт
	
	ФормыИФорматы = Новый ДеревоЗначений;
	ФормыИФорматы.Колонки.Добавить("Код");
	ФормыИФорматы.Колонки.Добавить("ДатаПриказа");
	ФормыИФорматы.Колонки.Добавить("НомерПриказа");
	ФормыИФорматы.Колонки.Добавить("ДатаНачалаДействия");
	ФормыИФорматы.Колонки.Добавить("ДатаОкончанияДействия");
	ФормыИФорматы.Колонки.Добавить("ИмяОбъекта");
	ФормыИФорматы.Колонки.Добавить("Описание");
	
	Форма20100901 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы,
	"1110011", '2010-07-07', "ММВ-7-3/321", "ФормаОтчета2010Кв4");
	ОпределитьФорматВДеревеФормИФорматов(Форма20100901, "5.01");
	
	Форма2013Кв4 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы,
	"1110011", '2013-11-14', "ММВ-7-3/501@", "ФормаОтчета2013Кв4");
	ОпределитьФорматВДеревеФормИФорматов(Форма2013Кв4, "5.02");
	
	Форма2017Кв4 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы,
	"1110011", '2017-06-14', "ММВ-7-3/505@", "ФормаОтчета2017Кв4");
	ОпределитьФорматВДеревеФормИФорматов(Форма2017Кв4, "5.03");
	
	Форма2024Кв1 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы,
	"1110011", '2023-11-17', "ЕД-7-3/853@", "ФормаОтчета2024Кв1");
	ОпределитьФорматВДеревеФормИФорматов(Форма2024Кв1, "5.04");
	
	Возврат ФормыИФорматы;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОпределитьФормуВДеревеФормИФорматов(ДеревоФормИФорматов, Код, ДатаПриказа = '00010101', НомерПриказа = "",
			ИмяОбъекта = "", ДатаНачалаДействия = '00010101', ДатаОкончанияДействия = '00010101', Описание = "")
	
	НовСтр = ДеревоФормИФорматов.Строки.Добавить();
	НовСтр.Код = СокрЛП(Код);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ДатаНачалаДействия;
	НовСтр.ДатаОкончанияДействия = ДатаОкончанияДействия;
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

Функция ОпределитьФорматВДеревеФормИФорматов(Форма, Версия, ДатаПриказа = '00010101', НомерПриказа = "",
			ДатаНачалаДействия = Неопределено, ДатаОкончанияДействия = Неопределено, ИмяОбъекта = "", Описание = "")
	
	НовСтр = Форма.Строки.Добавить();
	НовСтр.Код = СокрЛП(Версия);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ?(ДатаНачалаДействия = Неопределено, Форма.ДатаНачалаДействия, ДатаНачалаДействия);
	НовСтр.ДатаОкончанияДействия = ?(ДатаОкончанияДействия = Неопределено, Форма.ДатаОкончанияДействия, ДатаОкончанияДействия);
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

#КонецОбласти

#Область ПоказателиОценкиРискаВыезднойНалоговойПроверки

Процедура ПоказателиОценкиРискаВыезднойНалоговойПроверки(ТаблицаПоказателей, ОписаниеОтчета) Экспорт 
	
	СведенияОтчета = ОписаниеОтчета.РегламентированныйОтчет.ДанныеОтчета.Получить();
	
	ЗначениеПоказателя = 0;
	
	Если ОписаниеОтчета.ВыбраннаяФорма = "ФормаОтчета2024Кв1"
		ИЛИ ОписаниеОтчета.ВыбраннаяФорма = "ФормаОтчета2017Кв4" Тогда
		
		Если СведенияОтчета.Свойство("ОкружениеСохранения") Тогда // отчет сохранен в 2.0
			
		Иначе
			
			ДеревоРаздела1 = СведенияОтчета.ДанныеМногоуровневыхРазделов["Раздел1"];
			
			Для Каждого СтраницаРаздела Из ДеревоРаздела1.Строки Цикл
				
				ЗначениеПоказателя = ЗначениеПоказателя + СтраницаРаздела.Данные["П000010003003"];
				
				ДеревоМногострочнойЧасти = СтраницаРаздела.ДанныеМногострочныхЧастей["П00001М1"];
				Для Каждого СтрокаМнЧ Из ДеревоМногострочнойЧасти.Строки Цикл
					ЗначениеПоказателя = ЗначениеПоказателя + СтрокаМнЧ.Данные["П00001М105001"];
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЕсли;
		
	Иначе
		
		Для Каждого Лист Из СведенияОтчета.ДанныеМногостраничныхРазделов.Раздел1 Цикл
			ДанныеЛиста = Лист.Данные;
			НомерСтроки = 1;
			Постфикс = "_" + РегламентированнаяОтчетность.ЧислоВСтрокуЧГ0(НомерСтроки);
			ЗначениеПоказателя = ЗначениеПоказателя + РегламентированнаяОтчетность.ПоказательОтчета(ДанныеЛиста, "П000010003003");
			
			Пока ДанныеЛиста.Свойство("П000010005001" + Постфикс) Цикл
				ЗначениеПоказателя = ЗначениеПоказателя
				                   + ДанныеЛиста["П000010005001" + Постфикс];
				НомерСтроки = НомерСтроки + 1;
				Постфикс = "_" + РегламентированнаяОтчетность.ЧислоВСтрокуЧГ0(НомерСтроки);
			КонецЦикла;
		КонецЦикла;
		
	КонецЕсли;
	
	НоваяСтрока = ТаблицаПоказателей.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, ОписаниеОтчета);
	НоваяСтрока.Показатель = "СуммаСбораВодныеБиоресурсы";
	НоваяСтрока.ЗначениеПоказателя = ЗначениеПоказателя;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли