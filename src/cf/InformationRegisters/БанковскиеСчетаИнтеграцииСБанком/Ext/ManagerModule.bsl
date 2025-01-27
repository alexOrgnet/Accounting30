﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиОбновления

Процедура ЗаполнитьПриОбновлении() Экспорт
	
	НаборДанныхБанковскиеСчетаИнтеграции = РегистрыСведений.БанковскиеСчетаИнтеграцииСБанком.СоздатьНаборЗаписей();
	НаборДанныхБанковскиеСчетаИнтеграции.Прочитать();
	Если НаборДанныхБанковскиеСчетаИнтеграции.Количество() > 0 Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НастройкиИнтеграцииСБанками.Ссылка КАК НастройкаИнтеграции,
	|	БанковскиеСчета.Ссылка КАК БанковскийСчет,
	|	БанковскиеСчета.Владелец КАК Организация
	|ИЗ
	|	Справочник.НастройкиИнтеграцииСБанками КАК НастройкиИнтеграцииСБанками
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.НастройкиИнтеграцииСБанками.Банки КАК НастройкиИнтеграцииСБанкамиБанки
	|		ПО НастройкиИнтеграцииСБанками.Ссылка = НастройкиИнтеграцииСБанкамиБанки.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.БанковскиеСчета КАК БанковскиеСчета
	|		ПО (БанковскиеСчета.Банк = НастройкиИнтеграцииСБанкамиБанки.Банк)
	|			И (БанковскиеСчета.Владелец ССЫЛКА Справочник.Организации)
	|ГДЕ
	|	НастройкиИнтеграцииСБанками.ПометкаУдаления = ЛОЖЬ";
	
	БанковскиеСчетаИнтеграции = Запрос.Выполнить().Выгрузить();
	НаборДанныхБанковскиеСчетаИнтеграции.Загрузить(БанковскиеСчетаИнтеграции);
	ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборДанныхБанковскиеСчетаИнтеграции);
	
КонецПроцедуры

Процедура УдалитьБитыеСсылкиРесурсаНастройкаИнтеграцииПриОбновлении() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	БанковскиеСчетаИнтеграцииСБанком.БанковскийСчет КАК БанковскийСчет,
	|	БанковскиеСчетаИнтеграцииСБанком.Организация КАК Организация
	|ИЗ
	|	РегистрСведений.БанковскиеСчетаИнтеграцииСБанком КАК БанковскиеСчетаИнтеграцииСБанком
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НастройкиИнтеграцииСБанками КАК НастройкиИнтеграцииСБанками
	|		ПО БанковскиеСчетаИнтеграцииСБанком.НастройкаИнтеграции = НастройкиИнтеграцииСБанками.Ссылка
	|ГДЕ
	|	НастройкиИнтеграцииСБанками.Ссылка ЕСТЬ NULL";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НаборЗаписей = РегистрыСведений.БанковскиеСчетаИнтеграцииСБанком.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.БанковскийСчет.Установить(Выборка.БанковскийСчет);
		НаборЗаписей.Отбор.Организация.Установить(Выборка.Организация);
		ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
