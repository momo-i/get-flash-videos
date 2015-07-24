# Part of get-flash-videos. See get_flash_videos for copyright.
package FlashVideo::Site::Xhamster;

use strict;
use FlashVideo::Utils;
use File::Basename;

sub find_video {
  my ($self, $browser) = @_;

  my ($id, $title);
  if ($browser->content =~ m{http://\S+/movies/([0-9]+)/(\S+)\.html}) {
    $id = $1;
    $title = $2;
    debug "ID: $id, Title: $title";
  }

  my ($url, $ext, $regex);
  if ($browser->content =~ m{<video .* file="([^'"]+)"}) {
    $url = $1;
    $regex = qr/\.[^\.]+$/;
    $ext = ( fileparse( $url, $regex ) )[2];
    debug "URL: $url, Ext: $ext";
  }

  my $filename = title_to_filename(extract_title($browser), $ext);
  debug "Filename: $filename";

  $browser->get($url);
  $url = $browser->response->header('Location');

  return $url, $filename;
}

1;
