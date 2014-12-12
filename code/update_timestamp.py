## Script to update the timestamp of a resource on HDX (CKAN).
## This script is useful for front-end purposes.
## It allows users to know when a dataset was updated last,
## by navigating HDX resources based on their timestamps.

import ckanapi as ckan
import datetime as dt

def updateTimestamp(resource_id, key):

        # Basic definitions of the remote CKAN instance.
        hdx = ckan.RemoteCKAN('https://data.hdx.rwlabs.org/',
                apikey=key,
                user_agent='ckanapiexample/1.0')

        try:
                print('Updating resource:' + resource_id + '\n')
                print('On https://data.hdx.rwlabs.org/' + '\n')
                current_time = dt.datetime.now().time()
                t = "Last updated at: " + str(current_time)
                hdx.action.resource_update(id = resource_id,
                        description = t,
                        url = '')  # CKAN doesn't like httpS

        except ckan.errors.ValidationError:
                print 'You have missing parameters. Check the url and type are included.\n'

        except ckan.errors.NotFound:
                print 'Resource not found!\n'
