::Spina::Theme.register do |theme|
  theme.name = 'default'
  theme.title = 'Default Theme'

  theme.page_parts = [
    { name: 'text', title: 'Text', partable_type: 'Spina::Text' },
    { name: 'title', title: 'Title', partable_type: 'Spina::Line' },
    { name: 'Image', title: 'Image', partable_type: 'Spina::Photo' },
    { name: 'image_gallery', title: 'Image Gallery', partable_type: 'Spina::PhotoCollection' }
  ]

  theme.view_templates = [{
    name:         'homepage',
    title:        'Homepage',
    page_parts:   ['text']
  }, {
    name:         'registerspage',
    title:        'Registers',
    page_parts:   ['text']
  }, {
    name:         'show',
    title:        'Default',
    description:  'A simple page',
    usage:        'Use for your content',
    page_parts:   ['text']
  }]

  theme.custom_pages = [{
    name:           'homepage',
    title:          'Homepage',
    deletable:      false,
    view_template:  'homepage'
  }, {
    name:           'registerspage',
    title:          'Registers',
    deletable:      false,
    view_template:  'registerspage'
  }]

  theme.navigations = [{
    name: 'header',
    label: 'Header',
    auto_add_pages: true
  }]
end
