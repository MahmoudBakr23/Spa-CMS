//= require active_admin/base
//= require select2
//= require_tree .

$(document).ready(function () {
  function initAjaxSelects() {
    $(".ajax-client-select").select2({
      ajax: {
        url: function () {
          return $(this).data("url");
        },
        dataType: "json",
        delay: 250,
        data: function (params) {
          return { q: params.term };
        },
        processResults: function (data) {
          return { results: data };
        },
        cache: true,
      },
      minimumInputLength: 2,
      placeholder: $(this).data("placeholder") || "Search...",
      width: "100%",
    });
  }

  initAjaxSelects();
  $(document).on("has_many_add:after", initAjaxSelects);
});
