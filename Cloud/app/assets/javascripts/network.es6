$(() => {
  function checkStatus(response) {
    if (response.status >= 200 && response.status < 300) {
      return response
    } else {
      var error = new Error(response.statusText)
      error.response = response
      throw error
    }
  }

  $('[data-visualization~=network]').each((i, container) => {
    var url = $(container).data('source')
    var options = {
      interaction: {
        zoomView: false
      },
      nodes: {
        fixed: true,
        shape: 'box',
        shapeProperties: {
          borderRadius: 12
        },
        color: {
          border: '#7dd1e9',
          background: '#ffffff',
          highlight: {
            border: '#7dd1e9',
            background: '#f2fafc'
          }
        },
        font: '14px Gotham-Book #666666'
      },
      layout: {
        hierarchical: {
          direction: 'DU',
          sortMethod: 'directed'
        }
      }
    };
    fetch(url, {credentials: 'same-origin'})
      .then((checkStatus))
      .then((response) => response.json())
      .then((json) => new vis.Network(container, json, options))
      .catch((e) => $(container).find('.loading').html(e));
  });
});
