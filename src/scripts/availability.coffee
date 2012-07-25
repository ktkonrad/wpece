class Availability
  constructor: (@numCabins = 2) ->
    @occupied = {}
    @calendarIds = [
      'lv6qar50diur7kqt1s5vsrk3lo@group.calendar.google.com', # cabin 1
      '969cqum6os1qcnnqlcdlhhge34@group.calendar.google.com', # cabin 2
      'i0sm6j6p47jcta7r55dpgb8jmo@group.calendar.google.com', # cabin 4
      'fbp9ha04eolkj57ufkm1plcbu0@group.calendar.google.com'  # cabin 6
    ]
  

  # callback when google api is loaded
  ready: () =>
    true

  # execute callback for each blacked out date in month
  # monthDate - a moment date object
  blackoutMonth: (monthDate, callback) =>
    [year, month] = [monthDate.year(), monthDate.month()]
    if @occupied[year]?[month]
      # loop over days in month
      currentDay = monthDate.date(1)
      end = moment(currentDay).add('months', 1)
      while currentDay < end
        callback(currentDay) if @calendarIds.length - @occupied[year][month][currentDay.date()] < @numCabins # NOTE: @occupied[][][] may be undefined (this means 0 cabins are occupied)
        currentDay = currentDay.add('days', 1)
    else
      @updateAvailabilityForMonth(month, year, callback)
    
  # update @occupied for month/year
  # month - integer in 0-11
  # year - integer
  updateAvailabilityForMonth: (month, year, blackoutCallback) =>
    @getOccupiedRanges new Date(year, month), new Date(year, month+1), (resp) => @parseGapiResponse(resp, blackoutCallback)
      
  # use google calendar API to get occupied ranges between start and end
  # start - Date object
  # end - Date object
  getOccupiedRanges: (start, end, parseCallback) =>
    console.log "checking availability for #{start} to #{end}"
  
    req = gapi.client.request {
      path: '/calendar/v3/freeBusy',
      method: 'POST',
      body: {
        timeMin: start,
        timeMax: end,
        items: @calendarIds.map (id) => return {'id': id}
      }
    }
  
    req.execute (resp) =>
      parseCallback(resp)

  parseGapiResponse: (resp, blackoutCallback) =>
    @calendarIds.forEach (calendarId) =>
      resp.calendars[calendarId].busy.forEach (busyRange) =>
        # loop over days in range
        currentDay = moment(busyRange.start)
        end = moment(busyRange.end)
        while currentDay < end
          @incrementOccupiedCabins(currentDay, blackoutCallback)
          currentDay = currentDay.add('days', 1)

  # increment @occupied for date or set it to 1 if it is undefined
  # date - moment date object
  incrementOccupiedCabins: (date, blackoutCallback) =>
    [year, month, day] = [date.year(), date.month(), date.date()]
    @occupied[year] ?= {}
    @occupied[year][month] ?= {}
    @occupied[year][month][day] ?= 0
    @occupied[year][month][day]++
    blackoutCallback(date) if @calendarIds.length - @occupied[year]?[month]?[day] < @numCabins


# bind globally
window.Availability = Availability