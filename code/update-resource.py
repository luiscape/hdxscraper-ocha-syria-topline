## Simple script to update a resource in HDX / CKAN.

import ckanapi as ckan
import datetime as dt

def updateDateHDX(resource_id, key):

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