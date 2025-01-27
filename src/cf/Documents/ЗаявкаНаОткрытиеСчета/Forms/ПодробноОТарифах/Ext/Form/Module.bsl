﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	БанкиАдресХранилища	= Параметры.БанкиАдресХранилища;
	НомерГруппы			= Параметры.НомерГруппы;
	
	СведенияОБанках = ПолучитьИзВременногоХранилища(БанкиАдресХранилища);
	
	СведенияОБанке = СведенияОБанках.Найти(НомерГруппы, "НомерГруппы");
	Если СведенияОБанке = Неопределено Тогда
		
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Банк = СведенияОБанке.Банк;
	
	Заголовок = Заголовок + Банк;
	
	НомерПродукта = 0;
	
	СтруктураПоиска = Новый Структура("Банк,БанкДоступен", Банк, Истина);
	
	СтрокиСведений = СведенияОБанках.НайтиСтроки(СтруктураПоиска);

	СсылкаВсеТарифы = СтрокиСведений[0].СсылкаНаТаблицуТарифа;
	Элементы.СсылкаТарифныеДокументы1.Видимость = ЗначениеЗаполнено(СсылкаВсеТарифы);
	
	ВсеСсылкиНаТарифыОдинаковы = Истина;
	Для каждого СтрокаСведений Из СтрокиСведений Цикл
		
		ВсеСсылкиНаТарифыОдинаковы = ВсеСсылкиНаТарифыОдинаковы 
			И СсылкаВсеТарифы = СтрокаСведений.СсылкаНаТаблицуТарифа;
		
		НомерПродукта = НомерПродукта + 1;
		
		СуффиксГруппы = Формат(НомерПродукта, "ЧГ=");
		
		ИндексСведений = СведенияОБанках.Индекс(СтрокаСведений);
		
		СписокПродуктов.Добавить(
			Новый Структура("ИдентификаторПродукта, ИндексСведений, ТарифныеДокументы", 
				СтрокаСведений.ИдентификаторПродукта, ИндексСведений, СтрокаСведений.СсылкаНаТаблицуТарифа));

		Если НомерПродукта > 1 Тогда
			
			ЭлементГруппаТарифы = Элементы["ГруппаТарифы"];
			
			// Группа для описания тарифа банка
			ГруппаСтрока = Элементы.Добавить("ГруппаОписаниеТарифа" + СуффиксГруппы, Тип("ГруппаФормы"), ЭлементГруппаТарифы);
			ГруппаСтрока.Вид                              = ВидГруппыФормы.ОбычнаяГруппа;
			ГруппаСтрока.ОтображатьЗаголовок              = Ложь;
			ГруппаСтрока.Отображение                      = ОтображениеОбычнойГруппы.Нет;
			ГруппаСтрока.Группировка                      = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяЕслиВозможно;
			ГруппаСтрока.ВертикальноеПоложениеПодчиненных = ВертикальноеПоложениеЭлемента.Центр;
			ГруппаСтрока.РастягиватьПоГоризонтали = Истина;
			
			// Группа первой колонки описания.
			ГруппаЛеваяКолонка = Элементы.Добавить("ГруппаЛеваяКолонка" + СуффиксГруппы, Тип("ГруппаФормы"), ГруппаСтрока);
			ГруппаЛеваяКолонка.Вид                              = ВидГруппыФормы.ОбычнаяГруппа;
			ГруппаЛеваяКолонка.ОтображатьЗаголовок              = Ложь;
			ГруппаЛеваяКолонка.Отображение                      = ОтображениеОбычнойГруппы.Нет;
			ГруппаЛеваяКолонка.Группировка                      = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
			ГруппаЛеваяКолонка.Ширина                           = Элементы.ГруппаЛеваяКолонка1.Ширина;
			
			// Декорация для наименования продукта.
			НаименованиеПродукта = Элементы.Добавить("НаименованиеПродукта" + СуффиксГруппы, Тип("ДекорацияФормы"), ГруппаЛеваяКолонка);
			НаименованиеПродукта.Вид        = ВидДекорацииФормы.Надпись;
			НаименованиеПродукта.ЦветТекста = ЦветаСтиля.ЦветАкцента;
			
			// Декорация для подробного описания.
			ПодробноеОписание = Элементы.Добавить("ПодробноеОписание" + СуффиксГруппы, Тип("ДекорацияФормы"), ГруппаЛеваяКолонка);
			ПодробноеОписание.Вид = ВидДекорацииФормы.Надпись;
			ПодробноеОписание.АвтоМаксимальнаяШирина = Ложь;
			
			// Разделитель - линия.
			СсылкаДокументы = Элементы.Добавить("СсылкаТарифныеДокументы" + СуффиксГруппы, Тип("ДекорацияФормы"), ЭлементГруппаТарифы);
			СсылкаДокументы.Вид 		= ВидДекорацииФормы.Надпись;
			СсылкаДокументы.Гиперссылка = Истина;
			СсылкаДокументы.Заголовок	= "Тарифные документы";
			СсылкаДокументы.ГоризонтальноеПоложениеВГруппе = ГоризонтальноеПоложениеЭлемента.Право;
			СсылкаДокументы.УстановитьДействие("Нажатие", "СсылкаТарифныеДокументыНажатие"); 
			СсылкаДокументы.Видимость = ЗначениеЗаполнено(СтрокаСведений.СсылкаНаТаблицуТарифа);

			// Разделитель - линия.
			Разделитель = Элементы.Добавить("ДекорацияРазделитель" + СуффиксГруппы, Тип("ДекорацияФормы"), ЭлементГруппаТарифы);
			Разделитель.Вид                      = ВидДекорацииФормы.Картинка;
			Разделитель.Картинка                 = БиблиотекаКартинок.ГоризонтальныйРазделитель;
			Разделитель.РазмерКартинки           = РазмерКартинки.Черепица;
			Разделитель.АвтоМаксимальнаяШирина   = Ложь;
			Разделитель.РастягиватьПоГоризонтали = Истина;
			
			ИмяКоманды = "КомандаВыбрать" + СуффиксГруппы;
			
			НоваяКоманда = Команды.Добавить(ИмяКоманды);
			НоваяКоманда.Действие	= "КомандаВыбрать";
			НоваяКоманда.Заголовок	= "Выбрать";
			
			КнопкаВыбрать = Элементы.Добавить(ИмяКоманды, Тип("КнопкаФормы"), ГруппаСтрока);
			КнопкаВыбрать.ИмяКоманды = ИмяКоманды;
			КнопкаВыбрать.ГоризонтальноеПоложениеВГруппе = ГоризонтальноеПоложениеЭлемента.Право
			
		КонецЕсли;
		
		ПодробноеОписание = Элементы["ПодробноеОписание" + СуффиксГруппы];
		ПодробноеОписание.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(СтрокаСведений.ПодробноеОписание);
		
		НаименованиеПродукта = Элементы["НаименованиеПродукта" + СуффиксГруппы];
		НаименованиеПродукта.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(СтрокаСведений.НаименованиеПродукта);

	КонецЦикла;
	
	Если ВсеСсылкиНаТарифыОдинаковы И ЗначениеЗаполнено(СсылкаВсеТарифы) Тогда
		
		ИндексПродукта = 0;
		Для каждого ПродуктБанка Из СписокПродуктов Цикл
			ИндексПродукта = ИндексПродукта + 1;
			Элементы["СсылкаТарифныеДокументы" + ИндексПродукта].Видимость = Ложь;
		КонецЦикла;
		
		Элементы.ФормаОткрытьВсеТарифы.Видимость = Истина;
	Иначе
		Элементы.ФормаОткрытьВсеТарифы.Видимость = Ложь;
	КонецЕсли;
	
	КлючСохраненияПоложенияОкна = Строка(Новый УникальныйИдентификатор);
	
	Если ЭтотОбъект.Высота > 40 Тогда
		
		ЭтотОбъект.Высота = 40;

	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаВыбрать(Команда)
	
	НомерПункта = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ОбщегоНазначенияБПКлиентСервер.ОставитьВСтрокеТолькоЦифры(Команда.Имя));
	
	СтруктураВозврата = Новый Структура("Банк,ИдентификаторПродукта,НомерГруппы,ИндексСведений");
	СтруктураВозврата.Банк = Банк;
	СтруктураВозврата.НомерГруппы = НомерГруппы;
	
	ИнформацияДляРезультата = СписокПродуктов[НомерПункта - 1].Значение;
	
	СтруктураВозврата.ИдентификаторПродукта = ИнформацияДляРезультата.ИдентификаторПродукта;
	СтруктураВозврата.ИндексСведений = ИнформацияДляРезультата.ИндексСведений;
	
	Закрыть(СтруктураВозврата);

КонецПроцедуры


&НаКлиенте
Процедура ОткрытьТарифныеДокументы(Команда)
	
	ПерейтиПоНавигационнойСсылке(СсылкаВсеТарифы);

КонецПроцедуры

&НаКлиенте
Процедура СсылкаТарифныеДокументыНажатие(Элемент)
	
	НомерПункта = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ОбщегоНазначенияБПКлиентСервер.ОставитьВСтрокеТолькоЦифры(Элемент.Имя));
	ИнформацияОПункте = СписокПродуктов[НомерПункта - 1].Значение;
	
	Если ЗначениеЗаполнено(ИнформацияОПункте.ТарифныеДокументы) Тогда
		ПерейтиПоНавигационнойСсылке(ИнформацияОПункте.ТарифныеДокументы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
