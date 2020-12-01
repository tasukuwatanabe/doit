import { mount } from '@vue/test-utils';
import LabelList from '@/label-list';
import LabelModal from '@/label-modal'

describe('Testing App component', () => {
  const wrapper = mount(LabelList);

  it("label-modalコンポーネントが存在する", () => {
    const modal = wrapper.findComponent(LabelModal);

    expect(modal.exists()).toBe(true);
  });
});