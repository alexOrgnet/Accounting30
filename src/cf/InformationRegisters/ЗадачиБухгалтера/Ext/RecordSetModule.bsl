﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ОсновнаяОрганизация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	Для Каждого Запись Из ЭтотОбъект Цикл
		Если НЕ ЗначениеЗаполнено(Запись.Организация) Тогда
			Запись.Организация = ОсновнаяОрганизация;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ДатаСоздания = ТекущаяДатаСеанса();
	
	КлючиЗадач = РегистрыСведений.ЗадачиБухгалтера.КлючиЗадач();
	
	Для каждого СтрокаНабора Из ЭтотОбъект Цикл
		
		Если ПустаяСтрока(СтрокаНабора.НаименованиеСокращенное) Тогда
			СтрокаНабора.НаименованиеСокращенное = СтрокаНабора.Наименование;
		КонецЕсли;
		Если СтрокаНабора.ДатаСоздания = '00010101' Тогда
			СтрокаНабора.ДатаСоздания = ДатаСоздания;
		КонецЕсли;
		
		СтрокаНабора.ХешЗадачи = РегистрыСведений.ЗадачиБухгалтера.ХешЗаписи(СтрокаНабора, КлючиЗадач);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
