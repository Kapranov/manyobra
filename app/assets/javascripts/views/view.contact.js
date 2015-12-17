/*
Name: 			View - Contact
Written by: 	Zettheme - (http://www.zettheme.com)
Version: 		2.1.0
*/

(function($) {

	'use strict';

	/*
	Contact Form: Basic
	*/
	$('#new_message:not([data-type=advanced])').validate({
		submitHandler: function(form) {

			var $form = $(form),
				$messageSuccess = $('#contactSuccess'),
				$messageError = $('#contactError'),
				$submitButton = $(this.submitButton);

			$submitButton.button('loading');

			// Ajax Submit
			$.ajax({
				type: 'POST',
				url: $form.attr('action'),
				data: {
					name: $form.find('#message_name').val(),
					email: $form.find('#message_email').val(),
					subject: $form.find('#message_subject').val(),
					message: $form.find('#message_message').val()
				},
				dataType: 'json',
				complete: function(data) {
				
					if (data.responseJSON.response == 'success') {

						$messageSuccess.removeClass('hidden');
						$messageError.addClass('hidden');

						// Reset Form
						$form.find('.form-control')
							.val('')
							.blur()
							.parent()
							.removeClass('has-success')
							.removeClass('has-error')
							.find('label.error')
							.remove();

						if (($messageSuccess.offset().top - 80) < $(window).scrollTop()) {
							$('html, body').animate({
								scrollTop: $messageSuccess.offset().top - 80
							}, 300);
						}

						$submitButton.button('reset');
						
						return;

					} else {

						$messageError.removeClass('hidden');
						$messageSuccess.addClass('hidden');

						if (($messageError.offset().top - 80) < $(window).scrollTop()) {
							$('html, body').animate({
								scrollTop: $messageError.offset().top - 80
							}, 300);
						}

						$form.find('.has-success')
							.removeClass('has-success');
							
						$submitButton.button('reset');

					}

				}
			});
		}
	});

	/*
	Contact Form: Advanced
	*/
	$('#contactFormAdvanced, #contactForm[data-type=advanced]').validate({
		onkeyup: false,
		onclick: false,
		onfocusout: false,
		rules: {
			'captcha': {
				captcha: true
			},
			'checkboxes[]': {
				required: true
			},
			'radios': {
				required: true
			}
		}
	});

}).apply(this, [jQuery]);