$('#maintain_pipeline_id').dropdown({
  onChange: function (value, text, $selectedItem) {
    var search_url = new URL('/admin/pipelines/options', location.origin);
    search_url.searchParams.set('pipeline_id', value);

    Rails.ajax({url: search_url, type: 'GET', dataType: 'script'});
  }
});
$('#maintain_member_id').dropdown();
