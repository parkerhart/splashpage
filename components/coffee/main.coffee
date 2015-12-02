$(document).ready ->

	#Primary Elements
	win = $(window)
	theDoc = $('html, body')
	page = $('#page-wrap')
	form = $('#sales-form')
	contentBlock = $('.content-block')
	scrollLink = $('.jump-to-section')
	popup = $('.popup-block')

	#Form Elements
	submitForm = $('#sales-form')
	success = $('#success-overlay')
	fName = $('input[name="fname"]')
	lName = $('input[name="lname"]')
	email = $('input[name="email"]')
	phone = $('input[name="phone"]')
	city = $('input[name="city"]')
	state = $('input[name="state"]')
	residence = $('select[name="residence"]')
	price = $('select[name="price"]')
	comments = $('textarea[name="comments"]')
	successOvrly = $('#success-overlay')
	closeThanks = $('.close-thanks')
	
	#Error Variables
	errorSet = [];
	fnError = ""
	lnError = ""
	emError = ""
	phError = ""
	ctyError = ""
	resTypeError = ""
	prError = ""
	commError = ""

	#Regular Expressions
	alphaEx = /[a-zA-Z]/
	alphaNumEx = /[a-zA-Z0-9]/
	phNumEx1 = /\d{10}/
	emEx = /[a-z0-9._%+-]+(@)+[a-zA-Z0-9.-]+\.+[a-z]{2,4}/

	#Form Actions and Results
	apiURL = form.attr('action')

	selectFields = $('select')
	selectStates = $('select[name="states"]')
	selectStatus = $('select[name="agent"]')
	selectResType = $('select[name="residence"]')
	selectPrices = $('select[name="price"]')

	#Submit Event Block
	submitForm.submit (event) ->
		event.preventDefault()

		#Submission Values
		fnValue = fName.val()
		lnValue = lName.val()
		emValue = email.val()
		phValue = phone.val()
		ctyValue = city.val()
		stValue = state.val()
		resValue = residence.val()
		prValue = price.val()
		commValue = comments.val()
		formData = $(this)
		dataPrep = formData.serialize()

		#Error Variables
		fnError = ""
		lnError = ""
		emError = ""
		phError = ""
		ctyError = ""
		stError = ""
		resTypeError = ""
		prError = ""
		commError = ""

		#Lite Form Validation
		if fnValue == "" || alphaEx.test(fnValue) == false

			errorSet.push("fname")

		else

			errorSet.pop("fname")

		if lnValue == "" || alphaEx.test(lnValue) == false

			errorSet.push("lname")

		else

			lnError = ""

		if emValue == "" || emEx.test(emValue) == false

			errorSet.push("email")

		else

			emError = ""

		if phValue != "" && phNumEx1.test(phValue) == false

			errorSet.push("phone")

		else

			phError = ""

		if ctyValue != "" && alphaEx.test(ctyValue) == false

			errorSet.push("city")

		else

			ctyError = ""

		if resValue == "Select a type of residence"

			errorSet.push("residence")

		else

			resTypeError = ""

		if prValue == "Select a range"

			errorSet.push("price")

		else

			prError = ""

		if commValue != "" && alphaNumEx.test(commValue) == false

			errorSet.push("comments")

		else

			commError = ""

		#AJAX Post Request, if error variables are empty
		if errorSet.length == 0
			$.ajax
				url: apiURL
				type: 'POST'
				contentType: 'application/json; charset=utf-8'
				data: dataPrep
				dataType: 'jsonp'
				error: () ->

				success: () ->
					$('label').removeClass('active-error')
					$('body').addClass('success-active')
					winHght()
					successScroll()
		else
			$('label').removeClass("active-error")

			for err in errorSet
				$('label[for="' + err + '"]').addClass("active-error")

		errorSet.length = 0

	#Select Field Event Blocks
	initSelectFields = () ->
		states = selectStates.val()
		status = selectStatus.val()
		restype = selectResType.val()
		prices = selectPrices.val()
		
		selectStates.parent().find('.inner-display').html(states)
		selectStatus.parent().find('.inner-display').html(status)
		selectResType.parent().find('.inner-display').html(restype)
		selectPrices.parent().find('.inner-display').html(prices)

	coordinateResType = (setResType) ->
		selectResType.val(setResType)
		selectResType.parent().find('.inner-display').html(setResType)

	coordinateRange = (setRange) ->
		selectPrices.val(setRange)
		selectPrices.parent().find('.inner-display').html(setRange)
	
	updateSelectField = (elm) ->

		currentVal = elm.val()
		elm.parent().find('.inner-display').html(currentVal)

		if elm.attr('name') == "residence" || elm.attr('name') == "price"
			switch currentVal
				when "Select a type of residence" then coordinateRange "Select a range"
				when "Studio" then coordinateRange "$400k +"
				when "One Bedroom" then coordinateRange "$600k +"
				when "One Bedroom/Den" then coordinateRange "$700k +"
				when "Two Bedroom" then coordinateRange "$1.2M"
				when "Two Bedroom/Den" then coordinateRange "$1.3M +"
				when "Three Bedroom" then coordinateRange "$1.5M +"
				when "Select a range" then coordinateResType "Select a type of residence"
				when "$400k +" then coordinateResType "Studio"
				when "$600k +" then coordinateResType "One Bedroom"
				when "$700k +" then coordinateResType "One Bedroom/Den"
				when "$1.2M +" then coordinateResType "Two Bedroom"
				when "$1.3M +" then coordinateResType "Two Bedroom/Den"
				when "$1.5M +" then coordinateResType "Three Bedroom"

	selectFields.change ->
		selectedElm =  $(this)
		updateSelectField(selectedElm)

	closeThanks.click ->
		$('body').removeClass('success-active')

	successScroll = () ->
		theDoc.animate({ scrollTop: 0 }, 'slow');

	displayPopup = (pBlock) ->
		
		if not pBlock.hasClass('active')
			pBlock.addClass('active')
		else
			pBlock.removeClass('active')

	popup.mouseenter ->
		if page.width() > 1024
			popupBlock =  $(this)
			displayPopup(popupBlock)

	popup.mouseleave ->
		if page.width() > 1024
			popupBlock =  $(this)
			displayPopup(popupBlock)

	popup.click ->
		if page.width() <= 1024
			popupBlock =  $(this)
			displayPopup(popupBlock)

	#Scroll to contact section
	jumpToSection = (elm) ->

		setElm = elm

		getPos = contentBlock.offset()
		setPos = getPos.top - 51

		$(theDoc).animate({ scrollTop: setPos }, 'slow')

	scrollLink.click () ->

		selectedElm = $(this)

		jumpToSection(selectedElm)

	winHght = () ->
		setHght = page.height()
		successOvrly.height(setHght)

	win.resize ->
		winHght()

	#Initiate onload
	initSelectFields()
