Chart.defaults.global.maintainAspectRatio = false;
Chart.scaleService.updateScaleDefaults('time', {
  gridLines: {
    display: false
  }
});
Chart.scaleService.updateScaleDefaults('category', {
  gridLines: {
    display: false
  }
});
Chart.defaults.lineWithLimits = Chart.defaults.line;
Chart.controllers.lineWithLimits = Chart.controllers.line.extend({
  draw: function() {
    Chart.controllers.line.prototype.draw.apply(this, arguments);

    this.chart.data.datasets.forEach((set) => {
      if (set.limits == null) {
        return;
      }
      set.limits.forEach((limit) => {
        var ctx = this.chart.chart.ctx;
        var xScale = this.chart.scales['x-axis-0']
        var width = this.chart.chart.width;
        var limitCoord = this.calculatePointY(limit.value);
        ctx.beginPath()
        ctx.moveTo(xScale.left, limitCoord);
        ctx.strokeStyle = limit.color;
        ctx.lineTo(xScale.right, limitCoord);
        ctx.stroke();
      });
    });
  },
})

$(() => {
  function renderChart($container, json) {
    var $canvas = $container.find('canvas');

    var data = {
      labels: json.labels,
      datasets: [{
        label: json.label,
        borderColor: '#7dd1e9',
        backgroundColor: 'rgba(125, 209, 233, 0.3)',
        borderWidth: 1,
        pointRadius: 1,
        limits: json.limits,
        data: json.data
      }]
    }

    var options = {
      tooltips: {
        callbacks: {
          label: (item, data) => `${data.datasets[item.datasetIndex].label}: ${Math.round(item.yLabel * 10) / 10}`
        }
      },
      legend: {
        display: false
      },
      scales: {
        xAxes: [{
            type: json.type,
            position: 'bottom',
            time: {
              tooltipFormat: 'MMMM Do YYYY, h:mm a',
            },
            ticks: {
              minRotation: 45
            }
        }],
      }
    }

    if (json.limits) {
      var values = json.limits.map((limit) => limit.value);
      options.scales.yAxes = [{
        ticks: {
          suggestedMin: Math.min(...values),
          suggestedMax: Math.max(...values)
        }
      }];
      $container.find('.legend').css('visibility', 'visible');
    }

    $container.find('.loading').hide();
    var chart = new Chart($canvas, {
      type: 'lineWithLimits',
      data: data,
      options: options
    });
    $container.data('chart', chart);
  }

  $('.charts').each((_, wrapper) => {
    var $wrapper = $(wrapper);
    var selector = $wrapper.data('active');
    function loadCurrentChart() {
      var $container = $(selector).first();
      if ($container == null || $container.data('visited') || $container.data('source') == null) {
        return;
      }

      $container.data('visited', true)
      var url = $container.data('source');
      fetch(url, {
        credentials: 'same-origin',
        headers: {
          Accept: 'application/json'
        }
      }).then((response) => response.json())
      .then((json) => {
        if (json.data.length < 1) {
          $container.find('.loading').html('No Data to Show');
        }
        else if (json.data.length < 2) {
          $container.find('.loading').html('Not Enough Data');
        } else {
          renderChart($container, json);
        }
      });
    };

    function activateTab(name) {
      var $tab = $('<a>').data('target', `.${name}-tab`);
      $tab.on('shown.bs.tab', loadCurrentChart);
      $tab.tab('show');
    };

    function onSelect(target) {
      activateTab($(target).val());
    }

    function goToSlide(id) {
      $wrapper.find('.chart-carousel').slick('slickGoTo', $(id).data('slick-index'));
    }

    $wrapper.find('.chart-carousel').slick();
    $wrapper.find('.chart-carousel').on('afterChange', loadCurrentChart);

    $wrapper.find('.chart-select').change((e) => { onSelect(e.target) });
    $wrapper.find('.chart-select').trigger('change');

    $wrapper.find('.chart-link').click((e) => {
      e.preventDefault();
      var $link = $(e.target);
      goToSlide($link.data('slide'));
      $('.metric-select').val($link.data('tab')).change();
    });

    $wrapper.find('.chart-export').click((e) => {
      e.preventDefault();
      var url = $(selector).data('source');
      var $link = $('<a>').attr('href', url);
      $link[0].pathname += '.xlsx';
      window.location = $link.attr('href');
    });
  });
});
