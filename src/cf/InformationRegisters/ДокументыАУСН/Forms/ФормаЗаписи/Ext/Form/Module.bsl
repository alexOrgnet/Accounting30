﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СброситьРазмерыИПоложениеОкна();
	БанкиПоИдентификатору = РегистрыСведений.СостоянияИнтеграцииАУСН.Банки(Запись.Организация, Запись.ИдентификаторБанка);
	Если БанкиПоИдентификатору.Следующий() Тогда
		Банк = БанкиПоИдентификатору.Банк;
	КонецЕсли;
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если ВебКлиент Тогда
		ДанныеДокумента = СтрШаблон("%1.zip", Запись.Идентификатор);
	#Иначе
		ДанныеДокумента = ПолучитьИмяВременногоФайла("zip");
	#КонецЕсли

	СоставноеИмяФайла = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ДанныеДокумента);
	ИмяВременногоФайла = СоставноеИмяФайла.Имя;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если ФайлСоздан Тогда
		Отказ = Истина;
		ФайлСоздан = Ложь;
		ОбработчикУдаления = Новый ОписаниеОповещения("УдалитьФайлыЗавершено", ЭтотОбъект);
		Попытка
			НачатьУдалениеФайлов(ОбработчикУдаления, ДанныеДокумента);
		Исключение
			Закрыть();
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИмяВременногоФайлаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ФайлСоздан Тогда
		ФайловаяСистемаКлиент.ЗапуститьПрограмму(ДанныеДокумента);
	Иначе
		#Если ВебКлиент Тогда
			ОбработкаСозданияКаталога = Новый ОписаниеОповещения("СозданиеКаталога_Завершение", ЭтотОбъект);
			ФайловаяСистемаКлиент.СоздатьВременныйКаталог(ОбработкаСозданияКаталога);
		#Иначе
			ЗаписатьДанныеДокумента();
		#КонецЕсли
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

 &НаСервере
Процедура ПрочитатьПовторноНаСервере()
	
	ЗаписьДокумент = РеквизитФормыВЗначение("Запись");
	ЗаписьДокумент.Статус = Перечисления.СтатусыДокументовАУСН.ОтправленоПользователю; 
	ЗаписьДокумент.ПрочитатьПовторно = Ложь;
	ЗаписьДокумент.Записать();
	ЗначениеВРеквизитФормы(ЗаписьДокумент, "Запись");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаписатьДанныеДокумента()
	
	АдресХранилища = ДанныеДокументаАУСН();
	ОбработчикПослеЗаписиФайла = Новый ОписаниеОповещения("ОткрытьФайл", ЭтотОбъект);
	ПараметрыЗаписи = ФайловаяСистемаКлиент.ПараметрыСохраненияФайла();
	ПараметрыЗаписи.Интерактивно = Ложь;
	ФайловаяСистемаКлиент.СохранитьФайл(ОбработчикПослеЗаписиФайла, АдресХранилища, ДанныеДокумента, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Функция ДанныеДокументаАУСН()
	
	МенеджерЗаписи = РегистрыСведений.ДокументыАУСН.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Запись);
	МенеджерЗаписи.Прочитать();
	
	ДвоичныеДанные = Base64Значение(МенеджерЗаписи.Данные.Получить());
	Возврат ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура СозданиеКаталога_Завершение(ИмяКаталога, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(ИмяКаталога) Тогда
		ДанныеДокумента = СтрШаблон("%1%2%3", ИмяКаталога, ПолучитьРазделительПутиКлиента(), ДанныеДокумента);
		ЗаписатьДанныеДокумента();
	Иначе
		ОбработчикПослеЗаписиФайла = Новый ОписаниеОповещения("ОткрытьФайл", ЭтотОбъект);
		АдресХранилища = ДанныеДокументаАУСН();
		ФайловаяСистемаКлиент.СохранитьФайл(ОбработчикПослеЗаписиФайла, АдресХранилища, ДанныеДокумента);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайл(ПолученныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ПолученныеФайлы <> Неопределено Тогда
		ФайлСоздан = Истина;
		ФайловаяСистемаКлиент.ЗапуститьПрограмму(ДанныеДокумента);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьФайлыЗавершено(ДополнительныеПараметры) Экспорт
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьПовторно(Команда)
	
	ПрочитатьПовторноНаСервере();
	ИнтеграцияАУСНКлиент.ВыполнитьОбменССервисом(ЭтотОбъект, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = ИнтеграцияАУСНКлиент.ИмяСобытияОбменССервисом() Тогда
		Прочитать();
		УправлениеФормой(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Запись = Форма.Запись;
	Элементы.ТекстОшибки.Видимость = ЗначениеЗаполнено(Запись.ТекстОшибки);
	Элементы.ФормаПрочитатьПовторно.Видимость = ЗначениеЗаполнено(Запись.ТекстОшибки);
	Если ЗначениеЗаполнено(Запись.ТекстОшибки) Тогда
		Элементы.ФормаПрочитатьПовторно.КнопкаПоУмолчанию = Истина;
	Иначе
		Элементы.ФормаЗакрыть.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СброситьРазмерыИПоложениеОкна()
	
	Если ПравоДоступа("СохранениеДанныхПользователя", Метаданные) Тогда
		ХранилищеСистемныхНастроек.Удалить(
			ЭтотОбъект.ИмяФормы,
			"",
			ПользователиИнформационнойБазы.ТекущийПользователь().Имя);
	КонецЕсли;
	КлючСохраненияПоложенияОкна = Строка(Новый УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти