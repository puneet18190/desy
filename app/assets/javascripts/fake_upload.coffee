class FakeUpload

  constructor: (@$trigger) ->
    @$input = $("#{@$trigger.data('fake-upload-input-selector')}")
    @$show  = $("#{@$trigger.data('fake-upload-show-selector')}")

    @$show.val @$input.val()

    @$trigger.click (event) =>
      el = event.currentTarget
      $(el).blur()
      @$input.click()

    @$input.change (event) =>
      el = event.currentTarget
      @$show.val $(el).val()

window.FakeUpload = FakeUpload