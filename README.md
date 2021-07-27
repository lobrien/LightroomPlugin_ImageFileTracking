# Lightroom Plugin for tracking missing / external files

Note that src is in `.lrplugin` so hidden in casual UNIX `ls`.

Plugin creates a csv on user's desktop called `photo_paths`

`path, isAvailable, lightroom_timestamp`

Lightroom timestamp is from 2001-01-01 for some stupid reason. Should check with older photos to see if it goes negative properly. 

```python
lr_epoch = datetime.timestamp(datetime(2001,1,1))
datetime.fromtimestamp(lr_epoch + 404084725)
datetime.datetime(2013, 10, 21, 21, 45, 25)
```