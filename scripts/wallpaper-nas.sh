#!/usr/bin/env bash

log() {
    echo "wallpaper-nas.sh: $1" 1>&2
}

log "running wallpaper NAS sync from $(pwd)"

log 'installing gphotos-sync'
pip install gphotos-sync

log 'validating that $WALLPAPER_SECRETS is set'
if [[ -z "${WALLPAPER_SECRETS}" ]]; then
    log 'error!  $WALLPAPER_SECRETS" is not set!'
    exit 1
fi

log "writing secret to secrets.json"
echo "$WALLPAPER_SECRETS" > secrets.json

log "cleaning up secrets.json"
rm secrets.json

# FLASK_APP: 'app.py',
# FLASK_ENV: 'production',
# GPHOTOS_COMMAND_PATH: '$HOME/venvs/wallpaper/bin/gphotos-sync',
# PORT: port,
# SECRET_PATH: '$HOME/.wallpaper.json',
# STORAGE_PATH: '$HOME/wallpaper',

# gphotos-sync \
#     --album "Wallpaper" \
#     --use-hardlinks \
#     --omit-album-date \
#     --skip-video \
#     --secret "./secret.json" \
#     --use-flat-path \
#     "$(eval echo $STORAGE_PATH)"


# $(eval echo $GPHOTOS_COMMAND_PATH) \
#     --album "Wallpaper" \
#     --use-hardlinks \
#     --omit-album-date \
#     --skip-video \
#     --secret "$(eval echo $SECRET_PATH)" \
#     --use-flat-path \
#     "$(eval echo $STORAGE_PATH)"
