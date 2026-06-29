import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'xof'
})
export class XofPipe implements PipeTransform {

  transform(value: unknown, ...args: unknown[]): unknown {
    return null;
  }

}
