﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Пользователь = Пользователи.ТекущийПользователь();
	Если Пользователь = Пользователи.СсылкаНеуказанногоПользователя() Тогда
		ИмяПользователя = НСтр("ru = 'электронной почты'");
	Иначе
		ИмяПользователя = Пользователь.Наименование;
	КонецЕсли;
	
	СтрокаСТегами = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Элементы.ДекорацияШаг2Заголовок.Заголовок, ИмяПользователя);
	
	Элементы.ДекорацияШаг2Заголовок.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(СтрокаСТегами);
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияAndroidНажатие(Элемент)
	
	АдресСтраницы = "https://play.google.com/store/apps/details?id=com.e1c.MobileAccounting";
	ПерейтиПоНавигационнойСсылке(АдресСтраницы);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияiOSНажатие(Элемент)
	
	АдресСтраницы = "https://itunes.apple.com/ru/app/%D0%B8%D0%BF-6/id1210606612?mt=8";
	ПерейтиПоНавигационнойСсылке(АдресСтраницы);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияWinНажатие(Элемент)
	АдресСтраницы = "https://www.microsoft.com/ru-ru/store/p/%D0%98%D0%9F-6/9nsk8r36b0fp";
	ПерейтиПоНавигационнойСсылке(АдресСтраницы);
КонецПроцедуры

#КонецОбласти

