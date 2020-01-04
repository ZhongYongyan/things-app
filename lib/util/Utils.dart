String clearHtml(String html) {
  if(html==null)
    return '';
  return html.replaceAll('white-space: nowrap;', '').replaceAll('font-family: &quot;Microsoft YaHei&quot;;', '');
}
